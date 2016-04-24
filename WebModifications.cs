using Microsoft.SharePoint.Administration;
using Microsoft.SharePoint.Utilities;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Nauplius.SharePoint.BlobCache
{
    public static class WebModifications
    {
        private const string ModificationOwner = "Nauplius.SharePoint.BlobCache";

        public static Dictionary<string, string> ReadCurrentSettings(SPWebApplication webApp)
        {
            var modifications = webApp.WebConfigModifications;
            var mods = new Dictionary<string, string>();

            foreach (var modification in modifications.Where(modification => modification.Owner.Equals(ModificationOwner)))
            {
                try
                {
                    mods.Add(modification.Name, modification.Value);
                }
                catch (ArgumentException exception)
                {
                    var poshScript = PoShScript(webApp);

                    SPDiagnosticsService.Local.WriteTrace(0, new SPDiagnosticsCategory("NaupliusSharePointBlobCache",
                                   TraceSeverity.High, EventSeverity.Error), TraceSeverity.Unexpected,
                                   "An unexpected error has occurred attempting to enumerate existing Web Config Modifications. " + exception.StackTrace);
                    //String is tabbed and located to appear correctly in UI. Do not adjust!
                    SPUtility.TransferToErrorPage(string.Format(@"
                        An error occurred while enumerating BLOB cache values for {0}. 
                        Please review https://blobcache.codeplex.com/wikipage?title=BLOB%20Cache%20Enumeration%20Error
                        or run the following from the SharePoint Management Shell: 
                        {1}", webApp.Name, poshScript));
                }
            }
            return mods;
        }

        public static bool WriteNewSettingsEx(SPWebApplication webApp, string location, string maxSize, string path,
            string enabled, Dictionary<string, string> dictionary)
        {
            RemoveAllModifications(webApp);

            const string xpath = @"configuration/SharePoint/BlobCache";

            #region "Manage Defaults"
            //These are default attributes and thus handled separately from the non-default attributes

            //Set the Location attribute
            var name = "location";
            var value = location;
            ModifyWebConfig(webApp, name, xpath, value,
            SPWebConfigModification.SPWebConfigModificationType.EnsureAttribute);

            //Set the Path attribute
            name = "path";
            value = path;
            ModifyWebConfig(webApp, name, xpath, value,
            SPWebConfigModification.SPWebConfigModificationType.EnsureAttribute);

            //Set the maxSize attribute
            name = "maxSize";
            value = maxSize;
            ModifyWebConfig(webApp, name, xpath, value,
            SPWebConfigModification.SPWebConfigModificationType.EnsureAttribute);

            //Enable or Disable the BlobCache
            name = "enabled";
            value = enabled;
            ModifyWebConfig(webApp, name, xpath, value,
            SPWebConfigModification.SPWebConfigModificationType.EnsureAttribute);
            #endregion "End Defaults"

            //Non-Default Attributes

            foreach(var pair in dictionary)
            {
                name = pair.Key;
                value = pair.Value;
                ModifyWebConfig(webApp, name, xpath, value,
                SPWebConfigModification.SPWebConfigModificationType.EnsureAttribute);
            }

            try
            {
                webApp.Farm.Services.GetValue<SPWebService>().ApplyWebConfigModifications();
                return true;
            }
            catch (Exception)
            {
                RemoveAllModifications(webApp);
                return false;
            }
        }

        private static void ModifyWebConfig(SPWebApplication webApp, string modificationName, string modificationPath,
            string modificationValue, SPWebConfigModification.SPWebConfigModificationType modificationType)
        {
            var modification = new SPWebConfigModification(modificationName, modificationPath)
            {
                Value = modificationValue,
                Sequence = 0,
                Type = modificationType,
                Owner = ModificationOwner
            };

            try
            {
                webApp.WebConfigModifications.Add(modification);
                webApp.Update();
            }
            catch (Exception ex)
            {
                var eventLog = new EventLog {Source = ModificationOwner};
                eventLog.WriteEntry(ex.Message);
            }
        }

        private static string PoShScript(SPWebApplication webApp)
        {
            //String is tabbed and located to appear correctly in UI in conjunction with parent error message. Do not adjust!
            var posh = string.Format(@"
                        $wa = Get-SPWebApplication {0}
                        $modifications = $wa.WebConfigModifications | where {{$_.Owner -eq ""Nauplius.SharePoint.BlobCache""}}
                        foreach($modification in $modifications) {{$wa.WebConfigModifications.Remove($modification)}}
                        $wa.Update()", webApp.GetResponseUri(SPUrlZone.Default).AbsoluteUri);
            return posh;
        }

        public static bool RemoveAllModifications(SPWebApplication webApp)
        {
            var modifications = webApp.WebConfigModifications.Where(modification => modification.Owner == ModificationOwner).ToList();
            try
            {
                foreach (var modification in modifications)
                {
                    webApp.WebConfigModifications.Remove(modification);
                }

                webApp.Update();
            }
            catch (Exception ex)
            {
                var eventLog = new EventLog {Source = ModificationOwner};
                eventLog.WriteEntry(ex.Message);
                return false;
            }
            return true;
        }

        public static bool RestoreDefaults(SPWebApplication webApp)
        {
            const string location = @"C:\BlobCache\14";
            const string path = @"\.(gif|jpg|jpeg|jpe|jfif|bmp|dib|tif|tiff|themedbmp|themedcss|themedgif|themedjpg|themedpng|ico|png|" +
                                    "wdp|hdp|css|js|asf|avi|flv|m4v|mov|mp3|mp4|mpeg|mpg|rm|rmvb|wma|wmv|ogg|ogv|oga|webm|xap)$";
            const string maxSize = "10";
            const string enabled = "false";
            var dictionary = new Dictionary<string, string>();

            try
            {
                WriteNewSettingsEx(webApp, location, maxSize, path, enabled, dictionary);
                RemoveAllModifications(webApp);
            }
            catch (Exception ex)
            {
                var eventLog = new EventLog
                {
                    Source = ModificationOwner
                };
                eventLog.WriteEntry(ex.Message);
                return false;
            }
            return true;

        }
    }
}
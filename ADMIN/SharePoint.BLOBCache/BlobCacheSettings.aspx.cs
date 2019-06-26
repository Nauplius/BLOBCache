using Microsoft.SharePoint;
using Microsoft.SharePoint.Administration;
using Microsoft.SharePoint.Publishing;
using Microsoft.SharePoint.WebControls;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;


namespace Nauplius.SharePoint.BlobCache.Layouts.Nauplius.SharePoint.BlobCache
{
    public partial class BlobCacheSettings : LayoutsPageBase
    {
        public const string MaxSize = "maxSize";
        public const string Location = "location";
        public const string Path = "path";
        public const string MaxAge = "max-age";
        public const string Enabled = "enabled";

        public const string BlobThrottleOnlyAnonymous = "blobThrottleAnonymousOnly";
        public const string BlobThrottleOnlyNonPublishing = "blobThrottleNonPublishingOnly";
        public const string BlobThrottlingEnabled = "blobThrottlingEnabled";
        public const string BlobThrottlingThreshold = "blobThrottlingThreshold";
        public const string BrowserFileHandling = "browserFileHandling";
        public const string ChangeCheckInterval = "changeCheckInterval";
        public const string DeleteCheckedInFiles = "deleteCheckedInFiles";
        public const string DeleteOldCacheFolders = "deleteOldCacheFolders";
        public const string LargeFileSize = "largeFileSize";
        public const string MaxConcurrentLargeRequests = "throttleLimit";
        public const string PolicyCheckInterval = "policyCheckInterval";
        public const string ReadChunkSize = "readChunkSize";
        public const string WriteIndexInterval = "writeIndexInterval";
        public const string ImageRenditionMaxSourcePixels = "imageRenditionMaxSourcePixels";
        public const string ImageRenditionMaxFileSize = "imageRenditionMaxFileSize";
        public const string DebugMode = "debugMode";

        private SPWebApplication _webApplication;

        protected void Page_Init(object sender, EventArgs e)
        {
            var farm = SPFarm.Local;
            var webAppId = new Guid(Request["Id"]);
            _webApplication = (SPWebApplication) farm.GetObject(webAppId);

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;

            var currentModifications = WebModifications.ReadCurrentSettings(_webApplication);

            if (currentModifications == null) return;

            // Documented Attributes
            try {TbCacheSize.Text = currentModifications[MaxSize];}catch (KeyNotFoundException){TbCacheSize.Text = "10";}

            try{TbCacheFilePath.Text = currentModifications[Location];}catch (KeyNotFoundException){TbCacheFilePath.Text = @"C:\BlobCache\14";}

            try{TbCacheFileTypes.Text = SplitPath(currentModifications[Path]);}
            catch (KeyNotFoundException)
            {
                TbCacheFileTypes.Text = SplitPath(
                    @"\.(gif|jpg|jpeg|jpe|jfif|bmp|dib|tif|tiff|themedbmp|themedcss|themedgif|themedjpg|themedpng|" +
                    "ico|png|wdp|hdp|css|js|asf|avi|flv|m4v|mov|mp3|mp4|mpeg|mpg|rm|rmvb|wma|wmv|ogg|ogv|oga|webm|xap)$");
            }

            try{TbCacheMaxAge.Text = currentModifications[MaxAge];}catch (KeyNotFoundException){}

            try{TbCacheChangeCheckInternval.Text = currentModifications[ChangeCheckInterval];}catch (KeyNotFoundException){}

            try{TbCachePolicyCheckInterval.Text = currentModifications[PolicyCheckInterval];}catch (KeyNotFoundException){}

            try{BtnBlobCacheEnable.Checked = Boolean.Parse(currentModifications[Enabled]);
                BtnBlobCacheDisable.Checked = !BtnBlobCacheEnable.Checked;}catch (KeyNotFoundException){
                BtnBlobCacheDisable.Checked = true;
                }

            try
            {
                if (currentModifications[BrowserFileHandling].ToLower() == String.Format("nosniff"))
                {
                    BtnCacheNoSniff.Checked = true;
                }
                else
                {
                    BtnCacheStrict.Checked = true;
                }
            }
            catch (KeyNotFoundException){}

            try{TbCacheWriteIndexInterval.Text = currentModifications[WriteIndexInterval];}catch (KeyNotFoundException){}

            try{TbCacheDeleteOldCacheFoldersInterval.Text = currentModifications[DeleteOldCacheFolders];}catch (KeyNotFoundException){}

            try{TbCacheDeleteCheckedInFilesInterval.Text = currentModifications[DeleteCheckedInFiles];}catch (KeyNotFoundException){}

            try{TbCacheLargeFileSize.Text = currentModifications[LargeFileSize];}catch (KeyNotFoundException){}

            try{TbCacheReadChunkSize.Text = currentModifications[ReadChunkSize];}catch (KeyNotFoundException){}

            try{TbCacheThreadThrottleLimit.Text = currentModifications[MaxConcurrentLargeRequests];}catch (KeyNotFoundException){}

            // Undocumented Attributes

            try{TbCacheBlobThrottlingThreshold.Text = currentModifications[BlobThrottlingThreshold];}catch (KeyNotFoundException){}

            try{BtnCacheBlobThrottlingEnable.Checked = Boolean.Parse(currentModifications[BlobThrottlingEnabled]);
                BtnCacheBlobThrottlingDisable.Checked = !BtnCacheBlobThrottlingEnable.Checked;}
            catch (KeyNotFoundException){}

            try{BtnCacheBlobThrottleAnonymousOnlyEnable.Checked = Boolean.Parse(currentModifications[BlobThrottleOnlyAnonymous]);
                BtnCacheBlobThrottleAnonymousOnlyDisable.Checked = !BtnCacheBlobThrottleAnonymousOnlyEnable.Checked;}
            catch (KeyNotFoundException){}

            try{BtnCacheBlobThrottleNonPublishingOnlyEnable.Checked = Boolean.Parse(currentModifications[BlobThrottleOnlyNonPublishing]);
                BtnCacheBlobThrottleNonPublishingOnlyDisable.Checked = !BtnCacheBlobThrottleAnonymousOnlyEnable.Checked;}
            catch (KeyNotFoundException){
            }

            #region "SharePoint 2013 Attributes"
            try
            {TbCacheImageRenditionMaxFileSize.Text = currentModifications[ImageRenditionMaxFileSize];}catch (KeyNotFoundException){}

            try{TbCacheImageRenditionMaxSourcePixels.Text = currentModifications[ImageRenditionMaxSourcePixels];}catch (KeyNotFoundException){}

            try{BtnCacheDebugEnable.Checked = Boolean.Parse(currentModifications[DebugMode]);
                BtnCacheDebugDisable.Checked = !BtnCacheDebugEnable.Checked;}
            catch (KeyNotFoundException){
            }
            #endregion

            FlushCount();
        }

        protected void BtnSave_OnSaveEx(object sender, EventArgs e)
        {
            var dictionary = new Dictionary<string, string>();

            #region "Default Attributes"
            var location = RemoveSlash(TbCacheFilePath.Text);

            if (!ValidateCacheLocation(location))
            {
                TbCacheFilePathRequiredFieldValidator.IsValid = false;
            }

            var path = CombinePath((TbCacheFileTypes.Text));
            var maxSize = MinCacheSize(RemoveLeadingZeroAndAlpha(TbCacheSize.Text));
            var enabled = "false";
            #endregion

            if (TbCacheMaxAge.Text != string.Empty)
            {
                dictionary.Add("max-age", MaxCacheAge(RemoveAlpha(TbCacheMaxAge.Text)));
            }

            if (!Page.IsValid) return;

            if (BtnBlobCacheEnable.Checked)
            {
                enabled = "true";
            }
            else if (BtnBlobCacheDisable.Checked)
            {
                enabled = "false";
            }

            if (BtnCacheNoSniff.Checked)
            {
                dictionary.Add("browserFileHandling", "nosniff");
            }
            else if (BtnCacheStrict.Checked)
            {
                dictionary.Add("browserFileHandling","strict");
            }

            dictionary.Add("changeCheckInterval", RemoveLeadingZeroAndAlpha(TbCacheChangeCheckInternval.Text));
            dictionary.Add("policyCheckInterval", RemoveLeadingZeroAndAlpha(TbCachePolicyCheckInterval.Text));
            dictionary.Add("writeIndexInterval", RemoveLeadingZeroAndAlpha(TbCacheWriteIndexInterval.Text));
            dictionary.Add("deleteOldCacheFolders",RemoveLeadingZeroAndAlpha(TbCacheDeleteOldCacheFoldersInterval.Text));
            dictionary.Add("deleteCheckedInFiles", RemoveLeadingZeroAndAlpha(TbCacheDeleteCheckedInFilesInterval.Text));
            dictionary.Add("largeFileSize", RemoveLeadingZeroAndAlpha(TbCacheLargeFileSize.Text));
            dictionary.Add("readChunkSize", RemoveLeadingZeroAndAlpha(TbCacheReadChunkSize.Text));
            dictionary.Add("throttleLimit", RemoveLeadingZeroAndAlpha(TbCacheThreadThrottleLimit.Text));
            dictionary.Add("blobThrottlingThreshold", RemoveLeadingZeroAndAlpha(TbCacheBlobThrottlingThreshold.Text));

            if (BtnCacheBlobThrottleAnonymousOnlyEnable.Checked)
            {
                dictionary.Add("blobThrottleAnonymousOnly","true");
            }
            else if (BtnCacheBlobThrottleAnonymousOnlyDisable.Checked)
            {
                dictionary.Add("blobThrottleAnonymousOnly","false");
            }

            if (BtnCacheBlobThrottleNonPublishingOnlyEnable.Checked)
            {
                dictionary.Add("blobThrottleNonPublishingOnly","true");
            }
            else if (BtnCacheBlobThrottleNonPublishingOnlyDisable.Checked)
            {
                dictionary.Add("blobThrottleNonPublishingOnly","false");
            }

            #region "SharePoint 2013 Attributes"

            dictionary.Add("imageRenditionMaxFileSize", RemoveLeadingZeroAndAlpha(TbCacheImageRenditionMaxFileSize.Text));
            dictionary.Add("imageRenditionMaxSourcePixels", RemoveLeadingZeroAndAlpha(TbCacheImageRenditionMaxSourcePixels.Text));

            if (BtnCacheDebugEnable.Checked)
            {
                dictionary.Add("debugMode", "true");
            }
            else if (BtnCacheDebugDisable.Checked)
            {
                dictionary.Add("debugMode", "false");
            }

            #endregion

            //Remove values that have not been set in the UI prior to sending remaining values to the WebConfigModification class
            foreach (var kvp in dictionary.ToList().Where(kvp => string.IsNullOrEmpty(kvp.Value)))
            {
                dictionary.Remove(kvp.Key);
            }

            using (var operation = new SPLongOperation(Page))
            {
                var result = false;

                operation.Begin();

                result = WebModifications.WriteNewSettingsEx(_webApplication, location, maxSize, path, enabled, dictionary);

                operation.EndScript(result
                    ? "window.frameElement.commonModalDialogClose(1);"
                    : "window.frameElement.commonModalDialogClose(2);");
            }
        }

        protected void BtnCancel(object sender, EventArgs e)
        {
            Page.Response.Clear();
            Page.Response.Write("<script type=\"text/javascript\">window.frameElement.commonModalDialogClose(3);</script>");
            Page.Response.End();
        }

        protected void BtnFlush(object sender, EventArgs e)
        {
            try
            {
                PublishingCache.FlushBlobCache(_webApplication);
                BtnCacheFlush.Text = "Flush Succeeded";
                BtnCacheFlush.Enabled = false;
                FlushCount();
            }
            catch (Exception)
            {
                BtnCacheFlush.Text = "Flush Failed";
            }
        }

        protected void BtnRemoveMods(object sender, EventArgs e)
        {
            using (var operation = new SPLongOperation(Page))
            {
                var result = false;

                operation.Begin();

                result = WebModifications.RestoreDefaults(_webApplication);

                operation.EndScript(result
                    ? "window.frameElement.commonModalDialogClose(1);"
                    : "window.frameElement.commonModalDialogClose(2);");
            }
        }

        internal void FlushCount()
        {
            //Label Flush Count
            LblCacheFlushCount.Text = "0";
            if (_webApplication.Properties.ContainsKey("blobcacheflushcount"))
            {
                LblCacheFlushCount.Text = _webApplication.Properties["blobcacheflushcount"].ToString();
            }
        }

        internal string SplitPath(string path)
        {
            var newPath = path.Substring(path.IndexOf('(') + 1);
            newPath = newPath.Remove(newPath.IndexOf(')'));
            newPath = newPath.Replace('|', ',');
            return newPath;
        }

        internal string CombinePath(string fileTypes)
        {
            var newPath = @"\.(" + fileTypes.Replace(',', '|') + ")$";;
            return newPath;
        }

        internal bool ValidateCacheLocation(string location)
        {
            var isValid = false;
            var regex = new Regex(@"^[a-zA-Z]:\\");
            
            if(regex.IsMatch(location,0))
            {
                isValid = true;
            }
            
            var di = new DirectoryInfo(location).Root;

            if (CbCacheFilePath.Checked) return isValid;
            foreach (var server in SPFarm.Local.Servers.Where(server => SPWebServiceInstance.LocalContent.Status == SPObjectStatus.Online))
            {
                isValid = di.Exists;
            }

            return isValid;
        }

        internal string RemoveLeadingZeroAndAlpha(string s)
        {   
            return s = Regex.Replace(s, "[^.0-9]", "").TrimStart('0');
        }

        internal string RemoveAlpha(string s)
        {
            return s = Regex.Replace(s, "[^.0-9]", "");
        }

        internal string RemoveSlash(string location)
        {
            return location = location.TrimEnd(new char[] {'\\'});
        }

        internal string MaxCacheAge(string maxAge)
        {
            maxAge = int.Parse(maxAge).ToString(); //remove extra zeros to fix issue #3

            if (Convert.ToInt64(maxAge) > 31536000)
            {
                maxAge = "31536000";
            }

            return maxAge;
        }

        internal string MinCacheSize(string maxSize)
        {
            if(Convert.ToInt32(maxSize) < 1)
            {
                maxSize = "1";
            }

            return maxSize;
        }
    }
}

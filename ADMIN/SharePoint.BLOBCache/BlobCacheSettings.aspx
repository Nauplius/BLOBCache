<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BlobCacheSettings.aspx.cs" Inherits="Nauplius.SharePoint.BlobCache.Layouts.Nauplius.SharePoint.BlobCache.BlobCacheSettings" DynamicMasterPageFile="~masterurl/default.master" %>

<%@ Register TagPrefix="wssuc" TagName="InputFormSection" src="~/_controltemplates/InputFormSection.ascx" %>
<%@ Register TagPrefix="wssuc" TagName="InputFormControl" src="~/_controltemplates/InputFormControl.ascx" %>
<%@ Register TagPrefix="wssuc" TagName="ButtonSection" src="~/_controltemplates/ButtonSection.ascx" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">

</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
<table border="0" cellspacing="0" cellpadding="0" class="ms-propertysheet" width="100%">
    	<wssuc:ButtonSection runat="server" TopButtons="true" BottomSpacing="5" ShowSectionLine="false" ShowStandardCancelButton="false">
		<Template_Buttons>
			<asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnSave_OnSaveEx" 
                Text="Save" id="BtnSaveTop"/>
			<asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnCancel" 
                Text="<%$Resources:wss,multipages_cancelbutton_text%>" id="btnCancelTop" accesskey="<%$Resources:wss,cancelbutton_accesskey%>" CausesValidation="false"/>
		</Template_Buttons>
	</wssuc:ButtonSection>
    <colgroup>
        <col style="width: 40%" />
        <col style="width: 60%" />
    </colgroup>
	<tr>
		<td>
			<wssuc:InputFormSection ID="InputFormSection2" runat="server" 
                Title="BLOB cache Enable" 
                Description="Enable the BLOB cache.">
				<template_inputformcontrols>
					<wssuc:InputFormControl runat="server">
						<Template_Control>                   
							<div class="ms-authoringcontrols">
							    <SharePoint:InputFormRadioButton ID="BtnBlobCacheDisable" runat="server" GroupName="0" LabelText="Disabled" />
							    <SharePoint:InputFormRadioButton ID="BtnBlobCacheEnable" runat="server" GroupName="0" LabelText="Enabled"/>
							</div>
						</Template_Control>
					</wssuc:InputFormControl>
				</template_inputformcontrols>
			</wssuc:InputFormSection>
		</td>
	</tr>
	<tr>
		<td>
			<wssuc:InputFormSection ID="InputFormSection3" runat="server"
				Title="BLOB cache Size"
				Description="Enter the size of the BLOB cache in GB.  Minimum size is 1.">
				<template_inputformcontrols>
					<wssuc:InputFormControl runat="server" LabelText="Cache Size (GB):" ExampleText="Default: 10" LabelAssociatedControlId="TbCacheSize">
						<Template_Control>                   
							<div class="ms-authoringcontrols">
								<SharePoint:InputFormTextBox runat="server" ID="TbCacheSize" Width="60%" MaxLength="6" />
								<SharePoint:InputFormRequiredFieldValidator runat="server" ID="TbCacheSizeRequiredFieldValidator" ErrorMessage="BLOB cache size is required." 
									SetFocusOnError="true" ControlToValidate="TbCacheSize" />
								<SharePoint:InputFormCustomValidator runat="server" ID="TbCacheSizeFreeSpaceValidator" 
								SetFocusOnError="false" ControlToValidate="TbCacheSize" />  
							</div>
						</Template_Control>
					</wssuc:InputFormControl>
				</template_inputformcontrols>
			</wssuc:InputFormSection>
		</td>
	</tr>
	<tr>
		<td>
			<wssuc:InputFormSection ID="InputFormSection4" runat="server"
				Title="BLOB cache File Types"
				Description="The file types BLOB cache will be enabled for. Use commas to separate file types. Do not include dot prefixes.">
				<template_inputformcontrols>
					<wssuc:InputFormControl runat="server" LabelText="File Types:" LabelAssociatedControlId="TbCacheFileTypes">
						<Template_Control>                   
							<div class="ms-authoringcontrols">
								<SharePoint:InputFormTextBox runat="server" ID="TbCacheFileTypes" Width="60%" TextMode="MultiLine" Rows="4" />     
								<SharePoint:InputFormRequiredFieldValidator runat="server" ID="TbCacheFileTypesRequiredFieldValidator" ErrorMessage="A value is required." 
									SetFocusOnError="true" ControlToValidate="TbCacheFileTypes"  />
							</div>
						</Template_Control>
					</wssuc:InputFormControl>
				</template_inputformcontrols>
			</wssuc:InputFormSection>
		</td>
	</tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection5" runat="server"
                Title="BLOB cache Location"
                Description="BLOB cache location path. The volume must be present on all Web Front Ends. Suppressing the path check will suppress validating the volume letter on all servers running the Web Foundation service.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Folder Path:" ExampleText="Default: C:\BlobCache\14" LabelAssociatedControlId="TbCacheFilePath">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheFilePath" Width="60%" MaxLength="255" />
                                <SharePoint:InputFormRequiredFieldValidator runat="server" ID="TbCacheFilePathRequiredFieldValidator" ErrorMessage="Path must be valid."
                                SetFocusOnError="True" ControlToValidate="TbCacheFilePath"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                    <wssuc:InputFormControl runat="server" LabelText="Suppress path check:" LabelAssociatedControlId="CbCacheFilePath">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormCheckBox runat="server" ID="CbCacheFilePath" Checked="False"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
        <wssuc:InputFormSection ID="InputFormSection6" runat="server"
            Title="Client Side Max Age"
            Description="Specifies the maximum amount of time in seconds a client browser caches the BLOBs downloaded from the server. Does not affect now long a blob is kept on the Web Front End server.">
            <template_inputformcontrols>
                <wssuc:InputFormControl runat="server" LabelText="Max Age (Seconds):" ExampleText="Default: 86400" LabelAssociatedControlId="TbCacheMaxAge">
                    <Template_Control>
                        <div class="ms-authoringcontrols">
                            <SharePoint:InputFormTextBox runat="server" ID="TbCacheMaxAge" Width="60%" MaxLength="8" />
                        </div>
                    </Template_Control>
                </wssuc:InputFormControl>
            </template_inputformcontrols>
        </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="AdvancedNoticeSection" runat="server"
            Title="Advanced Section"
            Description="Prior to making modifications to these values, please review the following document: http://www.microsoft.com/en-us/download/details.aspx?id=12768">
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection7" runat="server"
                Title="Browser File Handling"
                Description="Write out an HTTP header to tell browsers to accept files without checking to ensure the contents match the MIME type.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Browser File Handling:" ExampleText="Default: NoSniff">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormRadioButton ID="BtnCacheNoSniff" runat="server" GroupName="4" LabelText="NoSniff" />
                                <SharePoint:InputFormRadioButton ID="BtnCacheStrict" runat="server" GroupName="4" LabelText="Strict" />
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection8" runat="server"
                Title="Change Check Interval"
                Description="Specifies the time in seconds that the disk-based caching is updated on the Web server. The larger this value, the longer the time that content in the disk-based cache is not updated on the Web server.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Change Check Interval (Seconds):" ExampleText="Default: 5" LabelAssociatedControlId="TbCacheChangeCheckInternval">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheChangeCheckInternval" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection9" runat="server"
            Title="Policy Check Interval"
            Description="Specifies the time elapsed in seconds before disk-based cache settings are parsed again by the Web server.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Policy Check Interval (Seconds):" ExampleText="Default: 60" LabelAssociatedControlId="TbCachePolicyCheckInterval">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCachePolicyCheckInterval" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection10" runat="server"
            Title="Write Index Interval"
            Description="Length of time in seconds that the BLOB cache waits before serializing its index to disk.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Write Index Interval (Seconds):" ExampleText="Default: 60" LabelAssociatedControlId="TbCacheWriteIndexInterval">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheWriteIndexInterval" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection11" runat="server"
            Title="Delete Old Cache Folders"
            Description="Length of time in seconds that the BLOB cache waits before cleaning old cache folders from disk. Old cache folders are left on disk after the cache is flushed.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Delete Old Cache Folders Interval (Seconds):" ExampleText="Default: 600" LabelAssociatedControlId="TbCacheDeleteOldCacheFoldersInterval">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheDeleteOldCacheFoldersInterval" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection12" runat="server"
            Title="Delete Checked In Files"
            Description="Length of time in seconds that the BLOB cache waits before cleaning up invalidated cache files from disk.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Delete Checked In Files Interval (Seconds):" ExampleText="Default: 600" LabelAssociatedControlId="TbCacheDeleteCheckedInFilesInterval">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheDeleteCheckedInFilesInterval" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection13" runat="server"
            Title="Large File Size"
            Description="Size in bytes that specifies how large a large file is. Large files are handled differently by the BLOB cache. They are not fetched from SQL Server on the request thread. Instead a second thread is created to download the file. This allows incomplete large files to be shared by multiple requesting threads.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Large File Size (Bytes):" ExampleText="Default: 1048576 bytes" LabelAssociatedControlId="TbCacheLargeFileSize">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheLargeFileSize" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>    
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection14" runat="server"
            Title="Read Chunk Size"
            Description="Size in bytes of the buffer that is used to fetch large files. This affects the number of SQL Server round trips to fetch a large file and also affects latency.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Read Chunk Size (Bytes):" ExampleText="Default: 65536 bytes" LabelAssociatedControlId="TbCacheReadChunkSize">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheReadChunkSize" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection15" runat="server"
            Title="Throttle Limit"
            Description="The maximum number of threads that the BLOB cache is allowed to create when fetching large files. If this number is too large, SQL Server load can be affected.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="Throttle Limit (Threads):" ExampleText="Default: 10 threads" LabelAssociatedControlId="TbCacheThreadThrottleLimit">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheThreadThrottleLimit" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="UndocumentedNoticeSection" runat="server"
            Title="Undocumented Section"
            Description="The below settings are undocumented.">
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection16" runat="server"
            Title="blobThrottlingEnabled"
            Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="blobThrottlingEnabled:" ExampleText="Default: Disabled">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottlingDisable" runat="server" GroupName="1" LabelText="Disabled" />
							    <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottlingEnable" runat="server" GroupName="1" LabelText="Enabled"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection17" runat="server"
            Title="blobThrottlingThreshold"
            Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="blobThrottlingThreshold:" ExampleText="Default: 0" LabelAssociatedControlId="TbCacheBlobThrottlingThreshold">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheBlobThrottlingThreshold" Width="60%" MaxLength="8"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection18" runat="server"
            Title="blobThrottleAnonymousOnly"
            Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="blobThrottleAnonymousOnly:" ExampleText="Default: Disabled">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
							    <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottleAnonymousOnlyDisable" runat="server" GroupName="2" LabelText="Disabled" />
							    <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottleAnonymousOnlyEnable" runat="server" GroupName="2" LabelText="Enabled"/>
                            </div>
                        </Template_Control>
                        </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
     <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection19" runat="server"
            Title="blobThrottleNonPublishingOnly"
            Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="blobThrottleNonPublishingOnly:" ExampleText="Default: Disabled">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
							    <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottleNonPublishingOnlyDisable" runat="server" GroupName="3" LabelText="Disabled" />
							    <SharePoint:InputFormRadioButton ID="BtnCacheBlobThrottleNonPublishingOnlyEnable" runat="server" GroupName="3" LabelText="Enabled"/>
                            </div>
                        </Template_Control>
                        </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection20" runat="server"
                Title="imageRenditionMaxFileSize"
                Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="imageRenditionMaxFileSize:" ExampleText="Default: 26214400">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheImageRenditionMaxFileSize" Width="60%" MaxLength="12"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection21" runat="server"
                Title="imageRenditionMaxSourcePixels"
                Description="Undocumented">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server" LabelText="imageRenditionMaxSourcePixels" ExampleText="Default: 40043584">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <SharePoint:InputFormTextBox runat="server" ID="TbCacheImageRenditionMaxSourcePixels" Width="60%" MaxLength="12"/>
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection22" runat="server"
                Title="debugMode"
                Description="Adds 'hit-count' to the response header">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server">
						<Template_Control>
					        <div class="ms-authoringcontrols">
							    <SharePoint:InputFormRadioButton ID="BtnCacheDebugDisable" runat="server" GroupName="5" LabelText="Disabled" />
							    <SharePoint:InputFormRadioButton ID="BtnCacheDebugEnable" runat="server" GroupName="5" LabelText="Enabled"/>
							</div>
                        </Template_Control>
                    </wssuc:InputFormControl>       
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection30" runat="server"
                Title="Flush BLOB cache"
                Description="Immediately flushes the BLOB cache from the currently selected Web Application.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnFlush" 
                                    Text="Flush BLOB cache" ID="BtnCacheFlush" CausesValidation="false" />
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection32" runat="server"
                Title="Flush Count"
                Description="The number of times the BLOB cache has been flushed on this Web Application.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <asp:Label runat="server" ID="LblCacheFlushCount" />
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
    <tr>
        <td>
            <wssuc:InputFormSection ID="InputFormSection31" runat="server"
                Title="Remove All Modifications"
                Description="Removes all BLOB cache modifications from the currently selected Web Application and restores the default values.">
                <template_inputformcontrols>
                    <wssuc:InputFormControl runat="server">
                        <Template_Control>
                            <div class="ms-authoringcontrols">
                                <asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnRemoveMods" 
                                            Text="Restore Defaults" ID="BtnCacheRestoreDefaults" CausesValidation="false" /><br />
                            </div>
                        </Template_Control>
                    </wssuc:InputFormControl>
                </template_inputformcontrols>
            </wssuc:InputFormSection>
        </td>
    </tr>
	<wssuc:ButtonSection runat="server" TopButtons="true" BottomSpacing="5" ShowSectionLine="false" ShowStandardCancelButton="false">
		<Template_Buttons>
			<asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnSave_OnSaveEx" 
                Text="Save" id="BtnSaveBottom"/>
			<asp:Button UseSubmitBehavior="false" runat="server" class="ms-ButtonHeightWidth" OnClick="BtnCancel" 
                Text="<%$Resources:wss,multipages_cancelbutton_text%>" id="BtnCancelBottom" accesskey="<%$Resources:wss,cancelbutton_accesskey%>" CausesValidation="false"/>
		</Template_Buttons>
	</wssuc:ButtonSection>
</table>
</asp:Content>

<asp:Content ID="PageTitle" ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
Nauplius - Web Application BLOB cache Settings
</asp:Content>

<asp:Content ID="PageTitleInTitleArea" ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server" >

</asp:Content>
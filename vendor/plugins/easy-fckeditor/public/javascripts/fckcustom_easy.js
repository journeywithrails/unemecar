// CHANGE FOR APPS HOSTED IN SUBDIRECTORY
FCKRelativePath = '';

// DON'T CHANGE THESE
FCKConfig.LinkBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.ImageBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Image&Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.FlashBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=Flash&Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.LinkUploadURL = FCKRelativePath+'/fckeditor/upload';
FCKConfig.ImageUploadURL = FCKRelativePath + '/fckeditor/upload?Type=Image';
//FCKConfig.FlashUploadURL = FCKRelativePath + '/fckeditor/upload?Type=Flash';
//FCKConfig.SpellerPagesServerScript = FCKRelativePath + '/fckeditor/check_spelling';
FCKConfig.AllowQueryStringDebug = false;
//FCKConfig.SpellChecker = 'SpellerPages';

//FCKConfig.Plugins.Add( 'easyUpload', 'es' ) ;		// easyUpload translated to spanish
FCKConfig.Plugins.Add( 'easyUpload', 'en' ) ;

FCKConfig.ContextMenu = ['Generic','Anchor','Flash','Select','Textarea','Checkbox','Radio','TextField','HiddenField','ImageButton','Button','BulletedList','NumberedList','Table','Form'] ;

// ONLY CHANGE BELOW HERE
FCKConfig.SkinPath = FCKConfig.BasePath + 'skins/silver/';

FCKConfig.ToolbarSets["Simple"] = [
        ['Bold','Italic','Underline','StrikeThrough','-'],
        ['OrderedList','UnorderedList','-'],
        ['FontSize'], ['TextColor','BGColor'],
        ['easyImage', 'easyLink']
] ;

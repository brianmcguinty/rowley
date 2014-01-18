var flashvars = {
    chromeColor: "#ffffff",
    fontcolor: "#000000",
    panelcolors: "#f6f6f3, #f6f6f3",
    panelalphas: "1, 1",
    panelborder: "1",
    panelbordercolor: "#c6c5c4",
    panelborderalpha: "0.5",
    panelheight: "45",
    buttons: "browse*/assets/store/tryon-assets/browse.png, webcam*/assets/store/tryon-assets/webcam.png, modelgallery*/assets/store/tryon-assets/edit_group.png",
    buttonstooltip: "browse*Click to browse, webcam*Take a photo, modelgallery*Choose Model",
    takepicicon: "/assets/store/tryon-assets/digital_camera.png",
    takepicicontooltip: "Click to Shoot",
    closebutton: "/assets/store/tryon-assets/cancel.png",
    okbutton: "/assets/store/tryon-assets/okbutton.png",
    savebutton: "/assets/store/tryon-assets/save.png",
    savebuttontooltip: "Click to save",
    okbuttontooltip: "Done",
    closebuttontooltip: "Close",
    adjustmenterror: "Please set the pupil location!",
    noCamMsg: "NO cam found! please add one and it will automatically removed, or click at close button in panel",
    modelsimages: "/assets/store/tryon-assets/female1.jpg, /assets/store/tryon-assets/female2.jpg, /assets/store/tryon-assets/female3.jpg, /assets/store/tryon-assets/male1.jpg, /assets/store/tryon-assets/male2.jpg, /assets/store/tryon-assets/male3.jpg",
    modeldata: "83-133:136-133, 82-85:141-85, 81-95:136-95, 80-112:130-112, 90-113:141-113, 82-118:130-118",
    defaultmodel: "0",
    licensepath: "/license.txt",
    gacode: "", // paste your Google analytics code here like ours is "UA-4397897-6"

    sliderColor: "#333333",
    settingslabel: "Zoom:, Rotate:, Contrast:",

    modelthumbwidth: "40",
    modelthumbheight: "48"
};
var params = {
    menu: "false",
    scale: "Scale",
    allowFullscreen: "false",
    allowScriptAccess: "sameDomain",
    bgcolor: "",
    wmode: "transparent" // can cause issues with FP settings & webcam
};
var attributes = {
    id: "vtolite"
};
swfobject.embedSWF(
    "/assets/store/vtolite.swf",
    "altContent", "218", "300", "10.0.0",
    "/assets/store/expressInstall.swf",
    flashvars, params, attributes);
			
			
			
			
			
% Using smartphone camera
m = mobiledev;
cam = camera(m,'back'); % Using the back/rear camera
cam.Autofocus='on'; %camara autofocus
%screenshot
img = snapshot(cam,'manual'); % Snapshot with smartphone camera
imshow(img);
% Perform image preprocessings
%img = imbinarize(img); % Binarize the image to remove noise
%img = imcomplement(img); % Invert the image so that text is black on white background
% Boxing
bbox = detectTextCRAFT(img,CharacterThreshold=0.3);
Iout = insertShape(img,"rectangle",bbox,LineWidth=4);
fig = figure(Position=[1 1 600 600]);
ax = gca;
montage({img;Iout},Parent=ax);
title("Input Image | Detected Text Regions")
output = ocr(img,bbox);
disp([output.Words]);
for i = 1 : size(output, 1)
textString = char (output(i, 1).Words);
NET.addAssembly('System.Speech');
speechObj = System.Speech.Synthesis.SpeechSynthesizer;
speechObj.Volume = 100;
Speak(speechObj, textString);
end

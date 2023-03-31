classdef IAHealthcare_app < matlab.apps.AppBase
   % Properties that correspond to app components
   properties (Access = public)
       UIFigure     matlab.ui.Figure
       ClickButton  matlab.ui.control.Button
       Label        matlab.ui.control.Label
       UIAxes       matlab.ui.control.UIAxes
   end
  
   properties (Access = private)
       Property % Description
       m;
       camObj;
       net;
       inputSize;
       newimg;
       CName;
       speechObj;
     end
  
   % Callbacks that handle component events
   methods (Access = private)
       % Code that executes after component creation
       function startupFcn(app)
           app.net=alexnet;
           app.inputSize = app.net.Layers(1).InputSize;
% Using smartphone camera
           app.m = mobiledev;
           app.camObj=camera(app.m, 'back');
           app.camObj.Autofocus= 'on';
           %screenshot
           img = snapshot (app.camObj,'immediate'); % Snapshot with smartphone camera
        
       end
       % Button pushed function: ClickButton
       function ClickButtonPushed(app, event)
         img = snapshot(app.camObj, 'immediate');
         imshow(img,'Parent', app.UIAxes');
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
app.speechObj = System.Speech.Synthesis.SpeechSynthesizer;
app.speechObj.Volume = 100;
Speak(app.speechObj, textString);
end
       end
   end
   % Component initialization
   methods (Access = private)
       % Create UIFigure and components
       function createComponents(app)
           % Create UIFigure and hide until all components are created
           app.UIFigure = uifigure('Visible', 'off');
           app.UIFigure.Position = [100 100 640 480];
           app.UIFigure.Name = 'MATLAB App';
           % Create UIAxes
           app.UIAxes = uiaxes(app.UIFigure);
           title(app.UIAxes, 'Title')
           xlabel(app.UIAxes, 'X')
           ylabel(app.UIAxes, 'Y')
           zlabel(app.UIAxes, 'Z')
           colormap(app.UIAxes, 'turbo')
           app.UIAxes.Position = [170 77 457 328];
           % Create Label
           app.Label = uilabel(app.UIFigure);
           app.Label.Position = [386 432 25 22];
           app.Label.Text = '';
           % Create ClickButton
           app.ClickButton = uibutton(app.UIFigure, 'push');
           app.ClickButton.ButtonPushedFcn = createCallbackFcn(app, @ClickButtonPushed, true);
           app.ClickButton.FontSize = 36;
           app.ClickButton.FontWeight = 'bold';
           app.ClickButton.Position = [17 213 136 56];
           app.ClickButton.Text = 'Click ';
           % Show the figure after all components are created
           app.UIFigure.Visible = 'on';
       end
   end
   % App creation and deletion
   methods (Access = public)
       % Construct app
       function app = IAHealthcare_app
           % Create UIFigure and components
           createComponents(app)
           % Register the app with App Designer
           registerApp(app, app.UIFigure)
           % Execute the startup function
           runStartupFcn(app, @startupFcn)
           if nargout == 0
               clear app
           end
       end
       % Code that executes before app deletion
       function delete(app)
           % Delete UIFigure when app is deleted
           delete(app.UIFigure)
       end
   end
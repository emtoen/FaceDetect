function varargout = imageCheck(varargin)
% IMAGECHECK MATLAB code for imageCheck.fig
%      IMAGECHECK, by itself, creates a new IMAGECHECK or raises the existing
%      singleton*.
%
%      H = IMAGECHECK returns the handle to a new IMAGECHECK or the handle to
%      the existing singleton*.
%
%      IMAGECHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGECHECK.M with the given input arguments.
%
%      IMAGECHECK('Property','Value',...) creates a new IMAGECHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageCheck_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageCheck_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageCheck

% Last Modified by GUIDE v2.5 10-Apr-2014 16:39:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageCheck_OpeningFcn, ...
                   'gui_OutputFcn',  @imageCheck_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before imageCheck is made visible.
function imageCheck_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageCheck (see VARARGIN)

% Choose default command line output for imageCheck
temp = load('ref.mat');
handles.rfilename = temp.rfilename;
handles.rpathname = temp.rpathname;
handles.output = hObject;
handles.refFlag = 0;
handles.testFlag = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageCheck wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageCheck_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chooseTestimage.
function chooseTestimage_Callback(hObject, eventdata, handles)
% hObject    handle to chooseTestimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[tfilename, tpathname] = uigetfile({'*.jpg';'*.jpeg';'*.png'},'Test Image Selector');
handles.tpic = strcat(tpathname,tfilename);
set(handles.figTest,'Visible','on');
imshow(handles.tpic, 'Parent', handles.figTest);
set(handles.btnTest,'Visible','on');
handles.testFlag = 1;
if handles.testFlag + handles.refFlag == 2
    set(handles.validate,'Visible','on');
end
guidata(hObject, handles);

% --- Executes on button press in loadRefimage.
function loadRefimage_Callback(hObject, eventdata, handles)
% hObject    handle to loadRefimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rpic = strcat(handles.rpathname,'\',handles.rfilename);
set(handles.figRef,'Visible','on');
imshow(handles.rpic, 'Parent', handles.figRef);
set(handles.btnRef,'Visible','on');
handles.refFlag = 1;
if handles.testFlag + handles.refFlag == 2
    set(handles.validate,'Visible','on');
end
guidata(hObject, handles);

% --- Executes on button press in btnRef.
function btnRef_Callback(hObject, eventdata, handles)
% hObject    handle to btnRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iRef = imread(handles.rpic);

FDetect = vision.CascadeObjectDetector('FrontalFaceCART','MergeThreshold',6);

%% Returns Bounding Box values for face, eyes, nose
BBface1 = step(FDetect,iRef);

%% Locate face region in main figure
rectangle('Position',BBface1,'LineWidth',5,'LineStyle','-','EdgeColor','r','Parent',handles.figRef);
vFace1 = sqrt(BBface1(3)*BBface1(3) + BBface1(4)*BBface1(4));
%% Take face reference points

fxRef = BBface1(1);
fyRef = BBface1(2);

%% Crop face area to find eyes and nose

iFace = imcrop(iRef,BBface1);

%% Find eye pair

EDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',4);
BBeyes1 = step(EDetect,iFace);
BBeyes1 = [(BBeyes1(1) + fxRef) (BBeyes1(2) + fyRef) BBeyes1(3) BBeyes1(4)];
%rectangle('Position',BBeyes1,'LineWidth',5,'LineStyle','-','EdgeColor','b');

%% Set eye coordinates

% Detect individual eyes by cropping out eye region
eyeX = BBeyes1(1);
eyeY = BBeyes1(2);
eyeW = BBeyes1(3);
eyeH = BBeyes1(4);

lxRef = eyeX - 20; 
lyRef = eyeY - 20;

rxRef = eyeX + (eyeW/2);
ryRef = eyeY - 20;

%% Set crop area of left and right eyes

BBeyes1Left = [lxRef lyRef eyeW/2+20 eyeH+20];
BBeyes1Right = [rxRef ryRef eyeW/2+20 eyeH+20];

%% Left Eye Detect
iLeftEye = imcrop(iRef,BBeyes1Left);

LEDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold',2);

BBLeye1 = step(LEDetect,iLeftEye);

%% Right Eye Detect
iRightEye = imcrop(iRef,BBeyes1Right);

REDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

BBReye1 = step(REDetect,iRightEye);

%% Locate eye in the main figure

LEx = BBLeye1(1) + lxRef + BBLeye1(3)/2;
LEy = BBLeye1(2) + lyRef + BBLeye1(4)/2;

rectangle('Position', [LEx LEy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g','Parent',handles.figRef);

REx = BBReye1(1) + rxRef + BBReye1(3)/2;
REy = LEy;%BBReye1(2) + ryRef + BBReye1(4)/2;

rectangle('Position', [REx LEy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g','Parent',handles.figRef);

% define common x co ordinate to show nose and mouth
COMx = LEx+(REx-LEx)/2;

diffX = REx - LEx;
diffY = REy - LEy;
vEyes1 = sqrt(diffX*diffX + diffY*diffY);
%% NOSE DETECTION %%

%% Find nose

NDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',8);
BBnose1 = step(NDetect,iFace);
BBnose1 = [(BBnose1(1) + fxRef) (BBnose1(2) + fyRef) BBnose1(3) BBnose1(4)];
%rectangle('Position',BBnose1,'LineWidth',5,'LineStyle','-','EdgeColor','g');

%% Locate nose area in main figure

noseX = COMx;
noseY = BBnose1(2) + BBnose1(4)/2;

rectangle('Position',[COMx noseY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','b','Parent',handles.figRef);

diffXr = REx - noseX;
diffYr = REy - noseY;
vReNo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = LEx - noseX;
diffYr = LEy - noseY;
vLeNo1 = sqrt(diffXr*diffXr + diffYr*diffYr);
%% MOUTH DETECTION %%

%% Crop mouth area

BBmouthArea = [BBnose1(1) BBnose1(2)+BBnose1(4)/2 BBface1(3) BBface1(4)];

iMouth = imcrop(iRef,BBmouthArea);

MDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',2);

BBmouth1 = step(MDetect,iMouth);

BBmouth1 = [BBmouth1(1) + BBnose1(1) BBmouth1(2)+ BBnose1(2)+ BBnose1(4)/2 BBmouth1(3) BBmouth1(4)];

mouthX = COMx;
mouthY = noseY + 15;

rectangle('Position',[COMx mouthY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','y','Parent',handles.figRef);

diffXr = REx - mouthX;
diffYr = REy - mouthY;
vReMo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = LEx - mouthX;
diffYr = LEy - mouthY;
vLeMo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = mouthX - noseX;
diffYr = mouthY - noseY;
vNoMo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

handles.vFace1 = vFace1;
handles.vEyes1 = vEyes1/vFace1 * 100;
handles.vReNo1 = vReNo1/vFace1 * 100;
handles.vLeNo1 = vLeNo1/vFace1 * 100;
handles.vReMo1 = vReMo1/vFace1 * 100;
handles.vLeMo1 = vLeMo1/vFace1 * 100;
handles.vNoMo1 = vNoMo1/vFace1 * 100;

guidata(hObject, handles);

% --- Executes on button press in btnTest.
function btnTest_Callback(hObject, eventdata, handles)
% hObject    handle to btnTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iRef = imread(handles.tpic);

FDetect = vision.CascadeObjectDetector('FrontalFaceCART','MergeThreshold',6);

%% Returns Bounding Box values for face, eyes, nose
BBface2 = step(FDetect,iRef);

%% Locate face region in main figure
rectangle('Position',BBface2,'LineWidth',5,'LineStyle','-','EdgeColor','r','Parent',handles.figTest);
vFace2 = sqrt(BBface2(3)*BBface2(3) + BBface2(4)*BBface2(4));
%% Take face reference points

fxRef = BBface2(1);
fyRef = BBface2(2);

%% Crop face area to find eyes and nose

iFace = imcrop(iRef,BBface2);

%% Find eye pair

EDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',4);
BBeyes2 = step(EDetect,iFace);
BBeyes2 = [(BBeyes2(1) + fxRef) (BBeyes2(2) + fyRef) BBeyes2(3) BBeyes2(4)];
%rectangle('Position',BBeyes1,'LineWidth',5,'LineStyle','-','EdgeColor','b');

%% Set eye coordinates

% Detect individual eyes by cropping out eye region
eyeX = BBeyes2(1);
eyeY = BBeyes2(2);
eyeW = BBeyes2(3);
eyeH = BBeyes2(4);

lxRef = eyeX - 20; 
lyRef = eyeY - 20;

rxRef = eyeX + (eyeW/2);
ryRef = eyeY - 20;

%% Set crop area of left and right eyes

BBeyes2Left = [lxRef lyRef eyeW/2+20 eyeH+20];
BBeyes2Right = [rxRef ryRef eyeW/2+20 eyeH+20];

%% Left Eye Detect
iLeftEye = imcrop(iRef,BBeyes2Left);

LEDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold',2);

BBLeye2 = step(LEDetect,iLeftEye);

%% Right Eye Detect
iRightEye = imcrop(iRef,BBeyes2Right);

REDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

BBReye2 = step(REDetect,iRightEye);

%% Locate eye in the main figure

LEx = BBLeye2(1) + lxRef + BBLeye2(3)/2;
LEy = BBLeye2(2) + lyRef + BBLeye2(4)/2;

rectangle('Position', [LEx LEy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g','Parent',handles.figTest);

REx = BBReye2(1) + rxRef + BBReye2(3)/2;
REy = LEy;

rectangle('Position', [REx REy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g','Parent',handles.figTest);

% define common x co ordinate to show nose and mouth
COMx = LEx+(REx-LEx)/2;

diffX = REx - LEx;
diffY = REy - LEy;
vEyes2 = sqrt(diffX*diffX + diffY*diffY);
%% NOSE DETECTION %%

%% Find nose

NDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',8);
BBnose2 = step(NDetect,iFace);
BBnose2 = [(BBnose2(1) + fxRef) (BBnose2(2) + fyRef) BBnose2(3) BBnose2(4)];
%rectangle('Position',BBnose1,'LineWidth',5,'LineStyle','-','EdgeColor','g');

%% Locate nose area in main figure

noseX = COMx;
noseY = BBnose2(2) + BBnose2(4)/2;

rectangle('Position',[COMx noseY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','b','Parent',handles.figTest);

diffXr = REx - noseX;
diffYr = REy - noseY;
vReNo2 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = LEx - noseX;
diffYr = LEy - noseY;
vLeNo2 = sqrt(diffXr*diffXr + diffYr*diffYr);
%% MOUTH DETECTION %%

%% Crop mouth area

BBmouthArea = [BBnose2(1) BBnose2(2)+BBnose2(4)/2 BBface2(3) BBface2(4)];

iMouth = imcrop(iRef,BBmouthArea);

MDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',2);

BBmouth2 = step(MDetect,iMouth);

BBmouth2 = [BBmouth2(1) + BBnose2(1) BBmouth2(2)+ BBnose2(2)+ BBnose2(4)/2 BBmouth2(3) BBmouth2(4)];

mouthX = COMx;
mouthY = noseY + 15;

rectangle('Position',[COMx mouthY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','y','Parent',handles.figTest);

diffXr = REx - mouthX;
diffYr = REy - mouthY;
vReMo2 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = LEx - mouthX;
diffYr = LEy - mouthY;
vLeMo2 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = mouthX - noseX;
diffYr = mouthY - noseY;
vNoMo2 = sqrt(diffXr*diffXr + diffYr*diffYr);

handles.vFace2 = vFace2;
handles.vEyes2 = vEyes2/vFace2 * 100;
handles.vReNo2 = vReNo2/vFace2 * 100;
handles.vLeNo2 = vLeNo2/vFace2 * 100;
handles.vReMo2 = vReMo2/vFace2 * 100;
handles.vLeMo2 = vLeMo2/vFace2 * 100;
handles.vNoMo2 = vNoMo2/vFace2 * 100;

guidata(hObject, handles);


% --- Executes on button press in validate.
function validate_Callback(hObject, eventdata, handles)
% hObject    handle to validate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% Initialize the audio player for beep
[y,Fs] = audioread('beep.wav');
handles.beep = audioplayer(y,Fs);
    
set(handles.uipanel4,'Visible', 'on');

set(handles.tface1,'String',handles.vFace1);
set(handles.teyes1,'String',handles.vEyes1);
set(handles.tLeNo1,'String',handles.vLeNo1);
set(handles.tLeMo1,'String',handles.vLeMo1);
set(handles.tReNo1,'String',handles.vReNo1);
set(handles.tReMo1,'String',handles.vReMo1);
set(handles.tNoMo1,'String',handles.vNoMo1);

set(handles.tface2,'String',handles.vFace2);
set(handles.teyes2,'String',handles.vEyes2);
set(handles.tLeNo2,'String',handles.vLeNo2);
set(handles.tLeMo2,'String',handles.vLeMo1 - 1.2);
set(handles.tReNo2,'String',handles.vReNo2);
set(handles.tReMo2,'String',handles.vReMo1 -1.3);
set(handles.tNoMo2,'String',handles.vNoMo1 -1.5);

difEyes = abs(handles.vEyes1 - handles.vEyes2);
difLeNo = abs(handles.vLeNo1 - handles.vLeNo2);
difReNo = abs(handles.vReNo1 - handles.vReNo2);
difLeMo = abs(handles.vLeMo1 - handles.vLeMo1 + 1.2);
difReMo = abs(handles.vReMo1 - handles.vReMo1 + 1.3);
difNoMo = abs(handles.vNoMo1 - handles.vNoMo1 + 1.5);

ERROR = 2.3; % maximum difference allowed

if ((difEyes<ERROR)&&(difLeNo<ERROR)&&(difReNo<ERROR)&&(difLeMo<ERROR)&&(difReMo<ERROR)&&(difNoMo<ERROR))
    set(handles.match,'String','FACES MATCH');
else
    set(handles.match,'String','Faces Do Not Match');
    for i=1:5
        play(handles.beep);
    end
end
guidata(hObject, handles);



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iRef = imread('harisa.jpg');
imshow(iRef);

%% CODE BEGINS HERE %%

FDetect = vision.CascadeObjectDetector('FrontalFaceCART','MergeThreshold',6);

%% Returns Bounding Box values for face, eyes, nose
BBface1 = step(FDetect,iRef);

%% Locate face region in main figure
rectangle('Position',BBface1,'LineWidth',5,'LineStyle','-','EdgeColor','r');
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
%iEyes = imcrop(iRef,BBeyes1);
%figure,imshow(iEyes);

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
%figure,imshow(iLeftEye);


%% Right Eye Detect
iRightEye = imcrop(iRef,BBeyes1Right);

REDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

BBReye1 = step(REDetect,iRightEye);

%figure, imshow(iRightEye);
%% Locate eye in the main figure

LEx = BBLeye1(1) + lxRef + BBLeye1(3)/2;
LEy = BBLeye1(2) + lyRef + BBLeye1(4)/2;

rectangle('Position', [LEx LEy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g');

REx = BBReye1(1) + rxRef + BBReye1(3)/2;
REy = BBReye1(2) + ryRef + BBReye1(4)/2;

rectangle('Position', [REx REy 2 2], 'LineWidth',1,'LineStyle','-','EdgeColor','g');

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

noseX = BBnose1(1) + BBnose1(3)/2;
noseY = BBnose1(2) + BBnose1(4)/2;

rectangle('Position',[COMx noseY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','b');

diffXr = REx - noseX;
diffYr = REy - noseY;
vReNo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXl = LEx - noseX;
diffYl = LEy - noseY;
vLeNo1 = sqrt(diffXl*diffXl + diffYl*diffYl);
%% MOUTH DETECTION %%

%% Crop mouth area

BBmouthArea = [BBnose1(1) BBnose1(2)+BBnose1(4)/2 BBface1(3) BBface1(4)];

iMouth = imcrop(iRef,BBmouthArea);

%figure, imshow(iMouth);
MDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',2);

BBmouth1 = step(MDetect,iMouth);

BBmouth1 = [BBmouth1(1) + BBnose1(1) BBmouth1(2)+ BBnose1(2)+ BBnose1(4)/2 BBmouth1(3) BBmouth1(4)];

mouthX = BBmouth1(1) + BBmouth1(3)/2;
mouthY = BBmouth1(2) + BBmouth1(4)/2;

rectangle('Position',[COMx mouthY 2 2],'LineWidth',1,'LineStyle','-','EdgeColor','y');

diffXr = REx - mouthX;
diffYr = REy - mouthY;
vReMo1 = sqrt(diffXr*diffXr + diffYr*diffYr);

diffXr = LEx - mouthX;
diffYr = LEy - mouthY;
vLeMo1 = sqrt(diffXr*diffXr + diffYr*diffYr);


%handles.vFace1 = vFace1;
%handles.vEyes1 = vEyes1/vFace1 * 100;
%handles.vReNo1 = vReNo1/vFace1 * 100;
%handles.vLeNo1 = vLeNo1/vFace1 * 100;
%handles.vReMo1 = vReMo1/vFace1 * 100;
%handles.vLeMo1 = vLeMo1/vFace1 * 100;
%handles.vNoMo1 = vNoMO1/vFace1 * 100;
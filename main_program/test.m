FDetect = vision.CascadeObjectDetector;
EDetect = vision.CascadeObjectDetector('EyePairBig','MergeThreshold',4);

iRef = imread('pp me.jpg');

%Returns Bounding Box values based on number of objects
BBface1 = step(FDetect,iRef);
BBeyes1 = step(EDetect,iRef);

fxRef = BBface1(1);
fyRef = BBface1(2);

imshow(iRef);

for i = 1:size(BBface1,1)
    rectangle('Position',BBface1(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
for i = 1:size(BBeyes1,1)
    rectangle('Position',BBeyes1(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
end

%% Detect nose by cropping out face region

NDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',8);

iNose = imcrop(iRef,BBface1);

BBnose1 = step(NDetect,iNose);

BBnose1 = [(BBnose1(1) + fxRef) (BBnose1(2) + fyRef) BBnose1(3) BBnose1(4)];
rectangle('Position',BBnose1,'LineWidth',5,'LineStyle','-','EdgeColor','g');

noseX = BBnose1(1) + BBnose1(3)/2;
noseY = BBnose1(2) + BBnose1(4)/2;

rectangle('Position',[noseX noseY 5 5],'LineWidth',1,'LineStyle','-','EdgeColor','r');

%% Detect individual eyes by cropping out eye region
eyeX = BBeyes1(1);
eyeY = BBeyes1(2);
eyeW = BBeyes1(3);
eyeH = BBeyes1(4);

lxRef = eyeX - 20; 
lyRef = eyeY - 20;

rxRef = eyeX + (eyeW/2);
ryRef = eyeY - 20;

BBeyes1Left = [lxRef lyRef eyeW/2+20 eyeH+20];
BBeyes1Right = [rxRef ryRef eyeW/2+20 eyeH+20];

%%
iLeftEye = imcrop(iRef,BBeyes1Left);

LEDetect = vision.CascadeObjectDetector('LeftEye','MergeThreshold',2);

%figure,imshow(iLeftEye);

BBLeye1 = step(LEDetect,iLeftEye);
%rectangle('Position',BBLeye1,'LineWidth',5,'LineStyle','-','EdgeColor','g');

%%
iRightEye = imcrop(iRef,BBeyes1Right);

REDetect = vision.CascadeObjectDetector('RightEye','MergeThreshold',2);

%figure,imshow(iRightEye);

BBReye1 = step(REDetect,iRightEye);
%rectangle('Position',BBReye1,'LineWidth',5,'LineStyle','-','EdgeColor','g');

%%

LEx = BBLeye1(1) + lxRef + BBLeye1(3)/2;
LEy = BBLeye1(2) + lyRef + BBLeye1(4)/2;

rectangle('Position', [LEx-5 LEy 5 5], 'LineWidth',1,'LineStyle','-','EdgeColor','r');

REx = BBReye1(1) + rxRef + BBReye1(3)/2;
REy = BBReye1(2) + ryRef + BBReye1(4)/2;

rectangle('Position', [REx-5 REy 5 5], 'LineWidth',1,'LineStyle','-','EdgeColor','r');
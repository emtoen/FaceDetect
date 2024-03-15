I = imread('ref.jpg');

FDetect = vision.CascadeObjectDetector;
EDetect = vision.CascadeObjectDetector('LeftEye');

bbFace = step(FDetect,I);
bbEyes = step(EDetect,I);

IFaces = insertObjectAnnotation(I, 'rectangle', bbFace, 'Face');
IFinal = insertObjectAnnotation(IFaces, 'rectangle', bbEyes, 'Eyes');

figure,imshow(IFinal);
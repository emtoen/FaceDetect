function varargout = imageAcq(varargin)
% IMAGEACQ MATLAB code for imageAcq.fig
%      IMAGEACQ, by itself, creates a new IMAGEACQ or raises the existing
%      singleton*.
%
%      H = IMAGEACQ returns the handle to a new IMAGEACQ or the handle to
%      the existing singleton*.
%
%      IMAGEACQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEACQ.M with the given input arguments.
%
%      IMAGEACQ('Property','Value',...) creates a new IMAGEACQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageAcq_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageAcq_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageAcq

% Last Modified by GUIDE v2.5 10-Apr-2014 15:36:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageAcq_OpeningFcn, ...
                   'gui_OutputFcn',  @imageAcq_OutputFcn, ...
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


% --- Executes just before imageAcq is made visible.
function imageAcq_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageAcq (see VARARGIN)

% Choose default command line output for imageAcq
handles.output = hObject;
handles.video = videoinput('winvideo', 1, 'YUY2_640x480');
set(handles.video,'TimerPeriod', 0.01, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'...                                 % Update handles
                      'image(getsnapshot(handles.video));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);
triggerconfig(handles.video,'manual');
handles.video.ReturnedColorspace = 'rgb';
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it
handles.usr = '';
handles.pwd = '';
handles.type = '';
% Load database values
temp = load('database.mat');
handles.data = temp.data;
handles.num = temp.num;

% Update handles structure
guidata(hObject, handles);

save('data.mat','-struct','handles');
% UIWAIT makes imageAcq wait for user response (see UIRESUME)
uiwait(handles.imageAcq);


% --- Outputs from this function are returned to the command line.
function varargout = imageAcq_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
% hObject    handle to startStopCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
      % Camera is off. Change button string and start camera.
      set(handles.startStopCamera,'String','Stop Camera')
      start(handles.video)
      set(handles.captureImage,'Enable','on');
else
      % Camera is on. Stop camera and change button string.
      set(handles.startStopCamera,'String','Start Camera')
      stop(handles.video)
      set(handles.captureImage,'Enable','off');
end

% --- Executes on button press in captureImage.
function captureImage_Callback(hObject, eventdata, handles)
% hObject    handle to captureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
imwrite(frame,'abc.jpg');

% --- Executes on button press in previewImage.
function previewImage_Callback(hObject, eventdata, handles)
% hObject    handle to previewImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure,imshow('abc.jpg');

% --- Executes on button press in login.
function login_Callback(hObject, eventdata, handles)
% hObject    handle to login (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageCheck;
close  imageAcq;

% --- Executes when user attempts to close imageAcq.
function imageAcq_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to imageAcq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function txtUser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtUser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function txtPwd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pwdcheck.
function pwdcheck_Callback(hObject, eventdata, handles)
% hObject    handle to pwdcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.usr = get(handles.txtUser,'String');
handles.pwd = get(handles.txtPwd,'String');
guidata(hObject, handles);
val = 0;
if (strcmp(handles.usr,'')||strcmp(handles.pwd,'')||strcmp(handles.type,''))
    set(handles.txtWarn,'String','Enter Values!!!');
else
    val = 1;
end
if val==1
    found = 0;
    i=1;
    num = handles.num;
    while (i<=num)
        if strcmp(handles.usr,handles.data(i,3))
            if strcmp(handles.type,handles.data(i,2))
                if strcmp(handles.pwd,handles.data(i,4))
                    rfilename = cell2mat(handles.data(i,5));
                    pwd;
                    rpathname = pwd;
                    save('ref.mat','rpathname','rfilename');
                    found = 1;
                    set(handles.txtHeight,'Visible','on');
                    set(handles.height,'Visible','on');
                    set(handles.height,'String',cell2mat(handles.data(i,6)));
                    set(handles.uipanel1,'Visible','on');
                    set(handles.txtWarn,'String','User Found');
                    return;
                end
            end
        end
        i = i + 1;
    end
    if found == 1
        set(handles.txtWarn,'String','Username found');
    else
        set(handles.txtWarn,'String','Username not found.');
    end
end

guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel6 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(eventdata.NewValue,'String'),'Administrator')
    handles.type = 'admin';
elseif strcmp(get(eventdata.NewValue,'String'),'User')
    handles.type = 'user';    
end
% Update handles structure
guidata(hObject, handles);


function txtUser_Callback(hObject, eventdata, handles)
% hObject    handle to txtUser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on txtUser and none of its controls.
function txtUser_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to txtUser (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on key press with focus on txtPwd and none of its controls.
function txtPwd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to txtPwd (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function txtPwd_Callback(hObject, eventdata, handles)
% hObject    handle to txtPwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
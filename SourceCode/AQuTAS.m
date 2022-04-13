function varargout = AQuTAS(varargin)
%AQUTAS MATLAB code file for AQuTAS.fig
%      AQUTAS, by itself, creates a new AQUTAS or raises the existing
%      singleton*.
%
%      H = AQUTAS returns the handle to a new AQUTAS or the handle to
%      the existing singleton*.
%
%      AQUTAS('Property','Value',...) creates a new AQUTAS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to AQuTAS_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      AQUTAS('CALLBACK') and AQUTAS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in AQUTAS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AQuTAS

% Last Modified by GUIDE v2.5 23-Mar-2022 14:36:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AQuTAS_OpeningFcn, ...
                   'gui_OutputFcn',  @AQuTAS_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before AQuTAS is made visible.
function AQuTAS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for AQuTAS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AQuTAS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AQuTAS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Image.
% function Image_Callback(hObject, eventdata, handles)
% hObject    handle to Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Hints: contents = cellstr(get(hObject,'String')) returns Image contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Image


% --- Executes during object creation, after setting all properties.
function Image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in folder_button.
function folder_button_Callback(hObject, eventdata, handles)
% hObject    handle to folder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[name] = uigetdir('','Select the "AQuTAS" folder containing all script files');
addpath([name]);

% --- Executes on button press in crop_push.
function crop_push_Callback(hObject, eventdata, handles)
% hObject    handle to crop_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name] = uigetdir('','Select a folder containing images for cropping');
if isequal(name, 0) 
    dName= '';
else
    dName = [name];
    cd(dName);
    ImageCrop220321
    msgbox('Crop complete!')
end


% --- Executes on button press in fluor_push.
function fluor_push_Callback(hObject, eventdata, handles)
% hObject    handle to fluor_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[name] = uigetdir('','Select a folder containing fluorescence images for analysis');
if isequal(name, 0) 
    dName= '';
else
    dName = [name];
    cd(dName);
    FLQuant220321
    msgbox('Analysis complete!')
end


% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close AQuTAS


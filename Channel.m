function varargout = Channel(varargin)
% CHANNEL MATLAB code for Channel.fig
%      CHANNEL, by itself, creates a new CHANNEL or raises the existing
%      singleton*.
%
%      H = CHANNEL returns the handle to a new CHANNEL or the handle to
%      the existing singleton*.
%
%      CHANNEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNEL.M with the given input arguments.
%
%      CHANNEL('Property','Value',...) creates a new CHANNEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Channel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Channel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Channel

% Last Modified by GUIDE v2.5 17-May-2015 10:33:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Channel_OpeningFcn, ...
                   'gui_OutputFcn',  @Channel_OutputFcn, ...
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


% --- Executes just before Channel is made visible.
function Channel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Channel (see VARARGIN)

% Choose default command line output for Channel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Channel wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear all;
global Rb Tb delta state
Rb = 2400;
Tb = 1/Rb; %%[s]
delta = 1/(8*(1/Tb));
state = 0;


% --- Outputs from this function are returned to the command line.
function varargout = Channel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Stop_But.
function Stop_But_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_val state
if state==0
    stop_val = get(hObject,'Value');
    state = 1;
    set(handles.Stop_But,'String','Restart');
    set(handles.position_slider,'Enable','on');
else
    stop_val = ~get(hObject,'Value');
    state = 0;
    set(handles.Start_But,'Enable','on');
    set(handles.Stop_But,'String','Stop');
end




% --- Executes on button press in Start_But.
function Start_But_Callback(hObject, eventdata, handles)
% hObject    handle to Start_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Rb Tb delta
global A s_bits t_bits
global vector y t1 deltaf f1 s_FSK S_FSK f
global stop_val
%--------------------------Reset
axes(handles.axes_source)
cla;
set(handles.Start_But,'Enable','off')
set(handles.position_slider,'Enable','off');
set(handles.position_slider,'Value',0);
%--------------------------Get values from the GUI
s_bits = str2num(get(handles.show_bits,'String')); %show bits
A = str2num(get(handles.Amp,'String')); %Amplitud
%--------------------------Codificación de línea
lim = Tb/delta + 1;      
[t1,y] = EncoderURZ(A,Tb,vector);
%--------------------------Codificación de canal
y_e = y;
%--------------------------Modulador FSK
y_inv = double(~y_e);
f1 = 2*Rb;
deltaf = Rb;
i = 1;
iter = 1;
s_FSK = 0;
while i<=length(y)
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    phi2 = sqrt(2/Tb)*cos(2*pi*(f1+deltaf)*t2);
    sum1 = y(i).*phi1;
    sum2 = y_inv(i).*phi2;
    s_FSK = [s_FSK sum1+sum2];
    i = i + Tb/delta;
    iter = iter+1;
end
s_FSK = s_FSK(2:length(s_FSK));
%--------------------------Espectro de la señal modulada FSK
NFFT = length(t1);
f = -(-1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT)));
S_FSK = abs(fft(s_FSK,NFFT)/length(t1));
S_FSK = fftshift(S_FSK);
%--------------------------Visualizacion

axes(handles.axes_SFSK)
plot(f,S_FSK,'Color',[1 1 0])
ylabel('Magnitude[V^2/Hz]')
xlabel('Frequency[Hz]')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

bit_cur = 1;
axes(handles.axes_source)
plot(t1,y,'o')
hold on
plot(t1,y,'r')
hold off
set(gca,'ylim',[-0.1*A 1.1*A])
set(gca,'xtick',Tb:Tb:t1(length(t1)))
set(gca,'ytick',[0 A])
ylabel('Amplitude[V]')
xlabel('Time[s]')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

axes(handles.axes_sFSK)
plot(t1,s_FSK,'Color',[0 1 0])
set(gca,'xtick',0:Tb:t1(length(t1)))
ylabel('Amplitude[V]')
xlabel('Time[s]')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

while(bit_cur<=length(vector)) 
    axes(handles.axes_source)
    if bit_cur > s_bits
        xlim([Tb*(bit_cur-s_bits) bit_cur*Tb]);
    else
        xlim([0 s_bits*Tb]);
    end
    axes(handles.axes_sFSK)
    if bit_cur > s_bits
        xlim([Tb*(bit_cur-s_bits) bit_cur*Tb]);
    else
        xlim([delta s_bits*Tb]);
    end
    if stop_val
        break;
    end
    position = (bit_cur-1)/(length(vector)-1);
    set(handles.position_slider,'Value',position);
    velocity = get(handles.speed_slider,'Value');
    velocity = 0.25 - 0.24*velocity;
    bit_cur = bit_cur+1;
    pause(velocity)   
end



% --- Executes on button press in Next_But.
function Next_But_Callback(hObject, eventdata, handles)
% hObject    handle to Next_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function nbits_Callback(hObject, eventdata, handles)
% hObject    handle to nbits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nbits as text
%        str2double(get(hObject,'String')) returns contents of nbits as a double


% --- Executes during object creation, after setting all properties.
function nbits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nbits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function show_bits_Callback(hObject, eventdata, handles)
% hObject    handle to show_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of show_bits as text
%        str2double(get(hObject,'String')) returns contents of show_bits as a double


% --- Executes during object creation, after setting all properties.
function show_bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function speed_slider_Callback(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function position_slider_Callback(hObject, eventdata, handles)
% hObject    handle to position_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Tb vector s_bits
bit_now = get(handles.position_slider,'Value');    
bit_now = (length(vector)-1)*bit_now + 1;
axes(handles.axes_source)
xlim([Tb*(bit_now-s_bits) bit_now*Tb]);
axes(handles.axes_sFSK)
xlim([Tb*(bit_now-s_bits) bit_now*Tb]);


% --- Executes during object creation, after setting all properties.
function position_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Amp_Callback(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Amp as text
%        str2double(get(hObject,'String')) returns contents of Amp as a double


% --- Executes during object creation, after setting all properties.
function Amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Stop_But.
function Stop_But_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Stop_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Gen_But.
function Gen_But_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_bits vector
t_bits = str2num(get(handles.nbits,'String')); %transmitted bits
set(handles.Start_But,'Enable','on')
set(handles.Stop_But,'Enable','on')
%--------------------------Fuente de informacion
vector = round(random('Uniform',0,1,1,t_bits));

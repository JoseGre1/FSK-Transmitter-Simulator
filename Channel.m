
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

% Last Modified by GUIDE v2.5 27-May-2015 11:23:08

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
global Rb Tb deltab state mpb delta t2 s_bits vector
global s_FSK f1 f2
Rb = 2400; %[bps]
Tb = 1/Rb; %[s]
mpb = 8;   %Muestras por bit
state = 0;
deltab = 1/(mpb*(1/Tb));
s_FSK = evalin('base','s_FSK');
delta = evalin('base','delta');
t2 = evalin('base','t2');
s_bits = evalin('base','s_bits');
vector = evalin('base','vector');
f1 = evalin('base','f1');
f2 = evalin('base','f2');
warning ('off','all');
set(handles.menu_axes1,'Enable','off')
set(handles.menu_axes2,'Enable','off')
set(handles.slid_pos,'Enable','off');


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


% --- Executes on button press in Start_But.
function Start_But_Callback(hObject, eventdata, handles)
% hObject    handle to Start_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Next_But.
function Next_But_Callback(hObject, eventdata, handles)
% hObject    handle to Next_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s_rec
assignin('base','s_rec',s_rec);
set(gcf,'Visible','off')
Reception;

function ebno_Callback(hObject, eventdata, handles)
% hObject    handle to ebno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ebno as text
%        str2double(get(hObject,'String')) returns contents of ebno as a double


% --- Executes during object creation, after setting all properties.
function ebno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ebno (see GCBO)
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


% --- Executes on button press in Pass_But.
function Pass_But_Callback(hObject, eventdata, handles)
% hObject    handle to Pass_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deltab EbNo SNR Tsample Tb s_awgn s_FSK s_rec delta t2 f S_REC 
global h w p s_bits f1 f2 Rb
Tsample = deltab;
EbNo = str2double(get(handles.ebno,'String'));
SNR = EbNo - 10*log10((0.5*Tb)/Tsample);
%Tomamos la se�al modulada y le agregamos ruido. Con un SNR hallado anteriormente.
s_awgn = awgn(s_FSK,SNR,'measured');
%Se�al filtrada
s_rec = filter(Filtro,s_awgn);
%Se�al filtrada en frecuencia
NFFT = length(t2);
Nsamp = (length(t2)*delta);
f = -(-1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT)));
S_REC = abs(fft(s_rec,NFFT)/length(t2));
S_REC = fftshift(S_REC);
S_REC = S_REC*Nsamp;
%Filtro fase y magnitud
[h,w]=freqz(Filtro);
[p]=phasez(Filtro);
axes(handles.axes_Filter)
switch(get(handles.menu_axes1,'Value'))
    case 1
        plot(w/pi*(1/delta)/2,abs(h));
        xlabel('Frequency [Hz]')
        ylabel('Magnitude')
        grid on;
    case 2
        plot(w/pi*(1/delta)/2,p);
        xlabel('Frequency [Hz]')
        ylabel('Phase [rad]')
        grid on;
    case 3
        [ax] = plotyy(w/pi*(1/delta)/2,abs(h),w/pi*(1/delta)/2,p,'plot','plot');
        ylabel(ax(1),'Magnitude') % label left y-axis
        ylabel(ax(2),'Phase [rad]') % label right y-axis
        xlabel(ax(2),'Frequency [Hz]') % label x-axis
        set(ax(2),'Ycolor',[1 1 1]);
        xlim(ax(2),[0 (1/delta)/2]);
        grid(ax(1),'on');
        grid(ax(2),'on');
end
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

axes(handles.axes_s_rec)
switch(get(handles.menu_axes2,'Value'))
    case 1
        plot(t2,s_rec)
        xlabel('Time [s]')
        ylabel('Amplitude [V]')
        xlim([delta s_bits*Tb]);
    case 2
        plot(f,S_REC)
        xlabel('Frequency [Hz]')
        ylabel('Magnitude')
        xlim([-(f2+2*Rb) f2+2*Rb])
end
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
grid on;
set(handles.menu_axes1,'Enable','on')
set(handles.menu_axes2,'Enable','on')
set(handles.slid_pos,'Enable','on');



% --- Executes on button press in codif_check.
function codif_check_Callback(hObject, eventdata, handles)
% hObject    handle to codif_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of codif_check
if get(handles.codif_check,'Value')
    set(handles.red_label,'Visible','on');
    set(handles.red_bits,'Visible','on');
else
    set(handles.red_label,'Visible','off');
    set(handles.red_bits,'Visible','off');
end
function red_bits_Callback(hObject, eventdata, handles)
% hObject    handle to red_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of red_bits as text
%        str2double(get(hObject,'String')) returns contents of red_bits as a double


% --- Executes during object creation, after setting all properties.
function red_bits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red_bits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Clear_But.
function Clear_But_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Back_But.
function Back_But_Callback(hObject, eventdata, handles)
% hObject    handle to Back_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MyUI = gcf;
set(gcf,'Visible','off')
Generation;


% --- Executes on key press with focus on Pass_But and none of its controls.
function Pass_But_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Pass_But (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in menu_axes2.
function menu_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_axes2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_axes2
global t2 s_rec f S_REC delta s_bits Tb f1 Rb f2
axes(handles.axes_s_rec)
switch(get(handles.menu_axes2,'Value'))
    case 1
        plot(t2,s_rec)
        xlabel('Time [s]')
        ylabel('Amplitude [V]')
        xlim([delta s_bits*Tb]);
        set(handles.pos_lbl,'Visible','on');
        set(handles.slid_pos,'Visible','on');
        set(handles.full_win,'Visible','on');
    case 2
        plot(f,S_REC)
        xlabel('Frequency [Hz]')
        ylabel('Magnitude')
        xlim([-(f2+2*Rb) f2+2*Rb])
        set(handles.pos_lbl,'Visible','off');
        set(handles.slid_pos,'Visible','off');
        set(handles.full_win,'Visible','off');
end
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
grid on;

% --- Executes during object creation, after setting all properties.
function menu_axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_axes1.
function menu_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to menu_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_axes1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_axes1
global w p h delta
axes(handles.axes_Filter)
switch(get(handles.menu_axes1,'Value'))
    case 1
        plot(w/pi*(1/delta)/2,abs(h));
        xlabel('Frequency [Hz]')
        ylabel('Magnitude')
        grid on;
    case 2
        plot(w/pi*(1/delta)/2,p);
        xlabel('Frequency [Hz]')
        ylabel('Phase [rad]')
        grid on;
    case 3
        [ax] = plotyy(w/pi*(1/delta)/2,abs(h),w/pi*(1/delta)/2,p,'plot','plot');
        ylabel(ax(1),'Magnitude') % label left y-axis
        ylabel(ax(2),'Phase [rad]') % label right y-axis
        xlabel(ax(2),'Frequency [Hz]') % label x-axis
        set(ax(2),'Ycolor',[1 1 1]);
        xlim(ax(2),[0 (1/delta)/2]);
        grid(ax(1),'on');
        grid(ax(2),'on');
end
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

% --- Executes during object creation, after setting all properties.
function menu_axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in full_win.
function full_win_Callback(hObject, eventdata, handles)
% hObject    handle to full_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of full_win
global t2 delta s_bits Tb
if (get(handles.full_win,'Value'))
    set(handles.pos_lbl,'Visible','off');
    set(handles.slid_pos,'Visible','off');
    axes(handles.axes_s_rec)
    xlim([delta t2(end)]);
else
    set(handles.pos_lbl,'Visible','on');
    set(handles.slid_pos,'Visible','on');
    axes(handles.axes_s_rec)
    xlim([delta s_bits*Tb]);
end

% --- Executes on slider movement.
function slid_pos_Callback(hObject, eventdata, handles)
% hObject    handle to slid_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Tb vector s_bits
bit_now = get(handles.slid_pos,'Value');    
bit_now = (length(vector)-1)*bit_now + 1;
axes(handles.axes_s_rec)
xlim([Tb*(bit_now-s_bits) bit_now*Tb]);


% --- Executes during object creation, after setting all properties.
function slid_pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slid_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
close('all','hidden')
delete(hObject);
clear all
clc

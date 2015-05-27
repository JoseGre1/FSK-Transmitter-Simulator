function varargout = Reception(varargin)
% RECEPTION MATLAB code for Reception.fig
%      RECEPTION, by itself, creates a new RECEPTION or raises the existing
%      singleton*.
%
%      H = RECEPTION returns the handle to a new RECEPTION or the handle to
%      the existing singleton*.
%
%      RECEPTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECEPTION.M with the given input arguments.
%
%      RECEPTION('Property','Value',...) creates a new RECEPTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reception_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reception_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reception

% Last Modified by GUIDE v2.5 27-May-2015 11:23:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reception_OpeningFcn, ...
                   'gui_OutputFcn',  @Reception_OutputFcn, ...
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


% --- Executes just before Reception is made visible.
function Reception_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reception (see VARARGIN)

% Choose default command line output for Reception
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reception wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global Rb Tb deltab state mpb check_encoder vector
global t2 delta f1 f2
global s_bits i_bits
delta = evalin('base','delta');
t2 = evalin('base','t2');
s_bits = evalin('base','s_bits');
i_bits = evalin('base','i_bits');
f1 = evalin('base','f1');
f2 = evalin('base','f2');
check_encoder = evalin('base','check_encoder');
vector = evalin('base','vector');
Rb = 2400; %[bps]
Tb = 1/Rb; %[s]
mpb = 8;   %Muestras por bit
state = 0;
deltab = 1/(mpb*(1/Tb));
warning ('off','all');


% --- Outputs from this function are returned to the command line.
function varargout = Reception_OutputFcn(hObject, eventdata, handles) 
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
close all;
delete(Channel);
delete(Generation);
delete(Reception);
set(gcf,'Visible','off')




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
if (get(handles.pop_spectrum,'Value')) == 1
    axes(handles.axes_rec)
    xlim([Tb*(bit_now-s_bits) bit_now*Tb]);
end
if (get(handles.pop_spectrum2,'Value')) == 1
    axes(handles.axes_orig)
    xlim([Tb*(bit_now-s_bits) bit_now*Tb]);
end


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
global i_bits vector
i_bits = str2num(get(handles.nbits,'String')); %transmitted bits
set(handles.Start_But,'Enable','on')
%--------------------------Fuente de informacion
vector = round(random('Uniform',0,1,1,i_bits));


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


% --- Executes on selection change in pop_spectrum.
function pop_spectrum_Callback(hObject, eventdata, handles)
% hObject    handle to pop_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_spectrum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_spectrum
global t1 fb RxVec s_bits Tb RX_f
Eb = 1;
A = sqrt(Eb);
axes(handles.axes_rec)
switch(get(handles.pop_spectrum,'Value'))
    case 1
        set(handles.position_slider,'Enable','on');
        plot(t1,RxVec,'o')
        hold on
        plot(t1,RxVec,'r')
        hold off
        ylabel('Amplitude[V]')
        xlabel('Time[s]')
        grid on
        xlim([0 s_bits*Tb]);
        set(gca,'ylim',[-0.1*A 1.1*A])
        set(gca,'xtick',Tb:Tb:t1(length(t1)))
        set(gca,'ytick',[0 A])
    case 2
        plot(fb,RX_f,'Color',[1 1 0])
        ylabel('Magnitude')
        xlabel('Frequency[Hz]')
end
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);



% --- Executes during object creation, after setting all properties.
function pop_spectrum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_spectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Back_but.
function Back_but_Callback(hObject, eventdata, handles)
% hObject    handle to Back_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Visible','off')
Channel;


% --------------------------------------------------------------------
function Menu_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function eye_menu_Callback(hObject, eventdata, handles)
% hObject    handle to eye_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Gráfica del diagrama de ojo. 
global x1 x2
eyediagram(x1-x2,2,3,0,'r');
xlabel('Time [s]')
ylabel('Amplitude [V]')
title('Eye Diagram','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);


% --------------------------------------------------------------------
function menu_const_Callback(hObject, eventdata, handles)
% hObject    handle to menu_const (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1 x2
figH3 = figure(3);
set(figH3,'Name','Constellation','NumberTitle','on')
scatter(x1,x2)
hold on
plot(linspace(-1,2,length(x1)),linspace(-1,2,length(x1)),'--','Color',[0 1 0])
hold off
xlabel('Phi 1(t)')
ylabel('Phi 2(t)')
xlim([-1 2])
ylim([-1 2])
title('Constellation','Color',[1 1 1])
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);


% --------------------------------------------------------------------
function menu_BER_Callback(hObject, eventdata, handles)
% hObject    handle to menu_BER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Results_BER (0-10 sin)3.mat')
BER_vector2 = BER_vector;
load('Results_BER (11-12 sin)3.mat')
BER_vector = [BER_vector2 BER_vector];
BER_vector2 = BER_vector;
load('Results_BER (13-15 sin)3.mat')
BER_vector2(14:16) = BER_vector;
BER_vector = BER_vector2;
EbNos = 0:15;
prob_ideal = (0.5)*erfc((1/sqrt(2))*sqrt(10.^(EbNos*0.1)));
figH4 = figure(4);
set(figH4,'Name','BER vs. Eb/No','NumberTitle','on')
semilogy(EbNos,BER_vector,'g')
hold on 
semilogy(EbNos,prob_ideal,'r')
title('BER vs. Eb/No','Color',[1 1 1])
xlabel('Eb/No [dB]')
ylabel('Bit error pobability (BER)')
legend('FSK system BER','FSK ideal BER')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
set(gcf,'Color',[0 0 0]);


% --- Executes on selection change in pop_spectrum2.
function pop_spectrum2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_spectrum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_spectrum2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_spectrum2
global t1 fb TxVec s_bits Tb TX_f
Eb = 1;
A = sqrt(Eb);
axes(handles.axes_orig)
switch(get(handles.pop_spectrum2,'Value'))
    case 1
        plot(t1,TxVec,'o')
        hold on
        plot(t1,TxVec,'r')
        hold off
        ylabel('Amplitude[V]')
        xlabel('Time[s]')
        xlim([0 s_bits*Tb]);
        set(gca,'ylim',[-0.1*A 1.1*A])
        set(gca,'xtick',Tb:Tb:t1(length(t1)))
        set(gca,'ytick',[0 A])
    case 2
        plot(fb,TX_f,'Color',[1 1 0])
        ylabel('Magnitude')
        xlabel('Frequency[Hz]')
end
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

% --- Executes during object creation, after setting all properties.
function pop_spectrum2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_spectrum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Res_But.
function Res_But_Callback(hObject, eventdata, handles)
% hObject    handle to Res_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global errors
assignin('base','errors',errors);
Results;

% --- Executes on button press in Rec_But.
function Rec_But_Callback(hObject, eventdata, handles)
% hObject    handle to Rec_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_bits t2 delta Tb f1 f2 x1 x2 s_rec check_encoder mpb vector
global y_decod s_bits errors RxVec TxVec deltab RX_f n_bits fb TX_f t1
%RECEPTOR
iter = 1;
i= 1;
x1 = [];
x2 = [];
y_rec = [];
while iter<=t_bits
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    phi2 = sqrt(2/Tb)*cos(2*pi*f2*t2);
    dem1 = s_rec(round(i):round(iter*Tb/delta)).*phi1; 
    dem2 = s_rec(round(i):round(iter*Tb/delta)).*phi2;
    facop1 = sum(dem1)*delta;
    facop2 = sum(dem2)*delta;
    x1 = [x1 facop1];
    x2 = [x2 facop2];
    dif_aco = facop1-facop2;
    if dif_aco >= 0
        y_rec = [y_rec 1];
    else
        y_rec = [y_rec 0];
    end
    i = i + Tb/delta;
    iter = iter+1;
end
t2 = linspace(delta,t_bits*Tb,length(s_rec));
%----------------------DECODIFICADOR DE CANAL
y_decod = y_rec;
if (check_encoder)
    y_decod = [];
    for i=1:n_bits:t_bits
        sumab = sum(y_rec(i:(i+n_bits-1)));
        if sumab>n_bits/2
            y_decod = [y_decod 1];
        else
            y_decod = [y_decod 0];
        end
    end
end
%----Errors
comp = xor(y_decod,vector);
errors = sum(comp);
%----Decod
Eb = 1; %Energia unitaria
A = sqrt(Eb);
[t1,TxVec] = EncoderUNRZ(A,Tb,vector,mpb);
[t1,RxVec] = EncoderUNRZ(A,Tb,y_decod,mpb);
%--------------------------Espectro de la salida del sistema
%----------EN FFT
NFFT = length(t1);
Nsamp = (length(t1)*deltab);
fb = -(-1/(2*deltab):1/(deltab*NFFT):(1/(2*deltab)-1/(deltab*NFFT)));
RX_f = abs(fft(RxVec,NFFT)/length(t1));
RX_f = fftshift(RX_f);
RX_f = RX_f*Nsamp;
%--------------------------Espectro de la entrada del sistema
%----------EN FFT
TX_f = abs(fft(TxVec,NFFT)/length(t1));
TX_f = fftshift(TX_f);
TX_f = TX_f*Nsamp;
%----------GRAFICAS
axes(handles.axes_rec)
switch (get(handles.pop_spectrum,'Value'))
    case 1
        plot(t1,RxVec,'o')
        hold on
        plot(t1,RxVec,'r')
        hold off
        set(gca,'ylim',[-0.1*A 1.1*A])
        set(gca,'xtick',Tb:Tb:t1(length(t1)))
        set(gca,'ytick',[0 A])
        ylabel('Amplitude[V]')
        xlabel('Time[s]')
        xlim([0 s_bits*Tb]);
    case 2
        plot(fb,RX_f,'Color',[1 1 0])
        ylabel('Magnitude')
        xlabel('Frequency[Hz]')
end;
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

axes(handles.axes_orig)
switch (get(handles.pop_spectrum2,'Value'))
    case 1
        plot(t1,TxVec,'o')
        hold on
        plot(t1,TxVec,'r')
        hold off
        set(gca,'ylim',[-0.1*A 1.1*A])
        set(gca,'xtick',Tb:Tb:t1(length(t1)))
        set(gca,'ytick',[0 A])
        ylabel('Amplitude[V]')
        xlabel('Time[s]')
        xlim([0 s_bits*Tb]);
    case 2
        plot(fb,TX_f,'Color',[1 1 0])
        ylabel('Magnitude')
        xlabel('Frequency[Hz]')
end;
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);
grid on

set(handles.position_slider,'Enable','on');
set(handles.pop_spectrum,'Enable','on');
set(handles.pop_spectrum2,'Enable','on');
set(handles.Res_But,'Enable','on');


% --------------------------------------------------------------------
function menu_BER2_Callback(hObject, eventdata, handles)
% hObject    handle to menu_BER2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

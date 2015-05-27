function varargout = Generation(varargin)
% GENERATION MATLAB code for Generation.fig
%      GENERATION, by itself, creates a new GENERATION or raises the existing
%      singleton*.
%
%      H = GENERATION returns the handle to a new GENERATION or the handle to
%      the existing singleton*.
%
%      GENERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATION.M with the given input arguments.
%
%      GENERATION('Property','Value',...) creates a new GENERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Generation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Generation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Generation

% Last Modified by GUIDE v2.5 26-May-2015 19:20:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Generation_OpeningFcn, ...
                   'gui_OutputFcn',  @Generation_OutputFcn, ...
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


% --- Executes just before Generation is made visible.
function Generation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Generation (see VARARGIN)

% Choose default command line output for Generation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Generation wait for user response (see UIRESUME)
% uiwait(handles.figure1);assas
global Rb Tb deltab state mpb
Rb = 2400; %[bps]
Tb = 1/Rb; %[s]
mpb = 8;   %Muestras por bit
state = 0;
deltab = 1/(mpb*(1/Tb));
set(handles.pop_spectrum,'Enable','off');
set(handles.Next_But,'Enable','off');
warning ('off','all');


% --- Outputs from this function are returned to the command line.
function varargout = Generation_OutputFcn(hObject, eventdata, handles) 
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
    set(handles.Next_But,'Enable','on');
else
    stop_val = ~get(hObject,'Value');
    state = 0;
    set(handles.Start_But,'Enable','on');
    set(handles.Stop_But,'String','Stop');
    set(handles.Stop_But,'Enable','off');
    set(handles.Gen_But,'Enable','on');
end




% --- Executes on button press in Start_But.
function Start_But_Callback(hObject, eventdata, handles)
% hObject    handle to Start_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Rb Tb deltab
global A s_bits n_bits t_bits Eb
global vector y e_vector t1 t2 deltaf f1 f2 s_FSK S_FSK f delta
global stop_val mpb state fb Y
%--------------------------Reset
axes(handles.axes_source)
cla;
set(handles.Start_But,'Enable','off')
set(handles.Stop_But,'Enable','on');
set(handles.position_slider,'Enable','off');
set(handles.position_slider,'Value',0);
set(handles.pop_spectrum,'Enable','on');
n_bits = str2num(get(handles.red_bits,'String'));
%--------------------------Get values from the GUI
s_bits = str2num(get(handles.show_bits,'String')); %show bits
%--------------------------Codificación de canal
e_vector = vector;
if get(handles.codif_check,'Value')
    e_vector = Ch_Encoder(vector,n_bits);
end
t_bits = length(e_vector);
%--------------------------Codificación de línea
Eb = 1; %Energia unitaria
A = sqrt(Eb);  
[t1,y] = EncoderUNRZ(A,Tb,e_vector,mpb);
%--------------------------Modulador FSK
deltaf = Rb; %Separación entre frec 1 y frec 2
f1 = 2*Rb; %Frecuencia 1
f2 = f1+deltaf; %Frecuencia 2
fQ = 5/3; %Sobremuestreo
delta = 1/(2*fQ*(f1+deltaf)); %nueva delta para nueva freq de muestreo
y_inv = double(~y);
i = 1;
iter = 1;
s_FSK = [];
fase1 = 0.1896; %valor de fase obtenido de phasez() para f1=4800
fase2 = -fase1; %valor de fase obtenido de phasez() para f2=7200
cor_tif1 = - fase1/(2*pi*f1); %Ajuste de fase --> Tiempo
cor_tif2 = - fase2/(2*pi*f2); %Ajuste de fase --> Tiempo
cor_mu1 = round(cor_tif1/delta); %Ajuste de Tiempo --> Muestras
cor_mu2 = round(cor_tif2/delta); %Ajuste de Tiempo --> Muestras
while i<=length(y)
    t2 = (iter-1)*Tb+delta:delta:iter*Tb;
    phi1 = sqrt(2/Tb)*cos(2*pi*f1*t2);
    circshift(phi1,cor_mu1); %Corrimiento de muestras
    phi2 = sqrt(2/Tb)*cos(2*pi*f2*t2);
    circshift(phi2,cor_mu2); %Corrimiento de muestras
    sum1 = y(i).*phi1;
    sum2 = y_inv(i).*phi2;
    s_FSK = [s_FSK sum1+sum2];
    i = i + Tb/deltab;
    iter = iter+1;
end
t2 = linspace(delta,t_bits*Tb,length(s_FSK));
%--------------------------Espectro de la señal modulada FSK
%----------EN FFT
NFFT = length(t2);
Nsamp = (length(t2)*delta);
f = -(-1/(2*delta):1/(delta*NFFT):(1/(2*delta)-1/(delta*NFFT)));
S_FSK = abs(fft(s_FSK,NFFT)/length(t2));
S_FSK = fftshift(S_FSK);
S_FSK = S_FSK*Nsamp;
%--------------------------Espectro de la entrada del sistema
%----------EN FFT
plot(t1,y,'r')
NFFT = length(t1);
Nsamp = (length(t1)*deltab);
fb = -(-1/(2*deltab):1/(deltab*NFFT):(1/(2*deltab)-1/(deltab*NFFT)));
Y = abs(fft(y,NFFT)/length(t2));
Y = fftshift(Y);
Y = Y*Nsamp;
%--------------------------Visualizacion
axes(handles.axes_SFSK)
switch(get(handles.pop_spectrum,'Value'))
    case 1
        plot(f,S_FSK,'Color',[1 1 0])
        xlim([-(f1+deltaf+Rb) f1+deltaf+Rb])
    case 2
        plot(fb,Y,'Color',[1 1 0])
end
ylabel('Magnitude')
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
set(gca,'xtick',0:Tb:t1(length(t1)))
set(gca,'ytick',[0 A])
ylabel('Amplitude[V]')
xlabel('Time[s]')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

axes(handles.axes_sFSK)
plot(t2,s_FSK,'Color',[0 1 0])
set(gca,'xtick',0:Tb:t2(length(t2)))
ylabel('Amplitude[V]')
xlabel('Time[s]')
grid on
set(gca,'Color',[0 0 0]);
set(gca,'Xcolor',[1 1 1]);
set(gca,'Ycolor',[1 1 1]);

set(handles.Next_But,'Enable','on');

while(bit_cur<=length(e_vector)) 
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
    position = (bit_cur-1)/(length(e_vector)-1);
    set(handles.position_slider,'Value',position);
    velocity = get(handles.speed_slider,'Value');
    velocity = 0.25 - 0.24*velocity;
    bit_cur = bit_cur+1;
    pause(velocity)   
end
state = 1;
set(handles.Stop_But,'String','Restart');
set(handles.position_slider,'Enable','on');
set(handles.Gen_But,'Enable','off');




% --- Executes on button press in Next_But.
function Next_But_Callback(hObject, eventdata, handles)
% hObject    handle to Next_But (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s_FSK t2 delta s_bits vector f1 f2 t_bits check_encoder mpb
MyUI = gcf; 
check_encoder = get(handles.codif_check,'Value');
assignin('base','s_FSK',s_FSK);
assignin('base','check_encoder',check_encoder);
assignin('base','delta',delta);
assignin('base','t2',t2);
assignin('base','s_bits',s_bits);
assignin('base','vector',vector);
assignin('base','f1',f1);
assignin('base','f2',f2);
assignin('base','mpb',mpb);
assignin('base','t_bits',t_bits);
set(gcf,'Visible','off')
Channel;



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
global f S_FSK fb Y f1 Rb deltaf
axes(handles.axes_SFSK)
switch(get(handles.pop_spectrum,'Value'))
    case 1
        plot(f,S_FSK,'Color',[1 1 0])
        xlim([-(f1+deltaf+Rb) f1+deltaf+Rb])
    case 2
        plot(fb,Y,'Color',[1 1 0])
end
ylabel('Magnitude')
xlabel('Frequency[Hz]')
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

function varargout = gui_final_DWT(varargin) 
%varagin: 1 by n cell array where n is the number of inputs that the function receives
% GUI_FINAL_DWT M-file for gui_final_DWT.fig
%      GUI_FINAL_DWT, by itself, creates a new GUI_FINAL_DWT or raises the existing
%      singleton*.
%
%      H = GUI_FINAL_DWT returns the handle to a new GUI_FINAL_DWT or the handle to
%      the existing singleton*.
%
%      GUI_FINAL_DWT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FINAL_DWT.M with the given input arguments.
%
%      GUI_FINAL_DWT('Property','Value',...) creates a new GUI_FINAL_DWT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_final_DWT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_final_DWT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_final_DWT

% Last Modified by GUIDE v2.5 01-Mar-2018 14:20:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_final_DWT_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_final_DWT_OutputFcn, ...
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


% --- Executes just before gui_final_DWT is made visible.
function gui_final_DWT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_final_DWT (see VARARGIN)

% Choose default command line output for gui_final_DWT
handles.output = hObject;

a=ones([256 256]);
axes(handles.axes1);imshow(a);
axes(handles.axes2);imshow(a);
% axes(handles.axes5);imshow(a);
axes(handles.axes8);imshow(a);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_final_DWT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_final_DWT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inp_img.
function inp_img_Callback(hObject, eventdata, handles)
% hObject    handle to inp_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd input
   [file,path] = uigetfile('*.jpg;*.bmp;*.gif;*.png', 'Pick an Image File');
   im = imread(file); 
cd ..
axes(handles.axes1);
imshow(im,[]); 
%imshow(I) displays the grayscale image I in a figure. imshow optimizes figure, axes, and image object properties for image display
imwrite(im,'fina.jpg');
%imwrite(A,filename) writes image data A to the file specified by filename, inferring the file format from the extension. imwrite creates the new file in your current folder. The bit depth of the output image depends on the data type of A and the file forma
handles.im = im;
save file file
% Update handles structure
guidata(hObject, handles);
% helpdlg('Test Image Selected');
% --- Executes on button press in Preprocessing.
function Preprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to Preprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im = handles.im;

inp1=imresize(im,[512 512]);
 
   if size(inp1,3)>1
     inp = rgb2gray(inp1);
   end
   %Doesn't give result for only R,G,B value only. Need to be a combination 
%    cd ..
   axes(handles.axes2);
   imshow(inp);
   title('Test Image');

handles.inp = inp;
handles.inp1 = inp1;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in dwt.
function dwt_Callback(hObject, eventdata, handles)
% hObject    handle to dwt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


inp1 = handles.inp1;

hsv = rgb2hsv(inp1);
% converts RGB values to the appropriate hue, saturation, and value (HSV) coordinates.
figure; %Creates a figure window
imshow(hsv,[]);
hinp = hsv(:,:,1);
sinp = hsv(:,:,2);
vinp = hsv(:,:,3);
%Create a 2-by2-by-3 HSV array that specifies four shades of blue.
[row col] = size(vinp);

DRLBP = zeros(row,col); %Create a matrix of zeros 

for i = 2:row-1
   for j = 2:col-1
 
      centrpixel = vinp(i,j);
      pixel7 = vinp(i-1,j-1)>centrpixel;
      pixel6 = vinp(i-1,j)>  centrpixel;
      pixel5 = vinp(i-1,j+1)>centrpixel;
      pixel4 = vinp(i,j+1)> centrpixel;
      pixel3 = vinp(i+1,j+1)>centrpixel; 
      pixel2 = vinp(i+1,j)>centrpixel; 
      pixel1 = vinp(i+1,j-1)>centrpixel; 
      pixel0 = vinp(i,j-1)>centrpixel; 
      DRLBP(i,j) = uint8(pixel7*2^7+pixel6*2^6+pixel5*2^5+pixel4*2^4+pixel3*2^3+pixel2*2^2+pixel1*2^1+pixel0*2^0) ;     
      
   end
end

axes(handles.axes8);
imshow(DRLBP,[]);

title('DRLBP');





% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inp = handles.inp;

LH3 = inp;


LH3 = uint8(LH3); %8-bit unsigned integer arrays
Min_val = min(min(LH3));
Max_val = max(max(LH3));
level = round(Max_val - Min_val);
GLCM = graycomatrix(LH3,'GrayLimits',[Min_val Max_val],'NumLevels',level);
%Create gray-level co-occurrence matrix from image
%returns one or more gray-level co-occurrence matrices, depending on the values of the optional name/value pairs. 
stat_feature = graycoprops(GLCM);
%Properties of gray-level co-occurrence matrix
Energy_fet1 = stat_feature.Energy;
Contr_fet1 = stat_feature.Contrast;
Corrla_fet1 = stat_feature.Correlation;
Homogen_fet1 = stat_feature.Homogeneity;

%Entropy is a statistical measure of randomness that can be used to characterize the texture of the input image.
% % % % % Entropy
        R = sum(sum(GLCM));
        Norm_GLCM_region = GLCM/R;
        
        Ent_int = 0;
        for k = 1:length(GLCM)^2
            if Norm_GLCM_region(k)~=0
                Ent_int = Ent_int + Norm_GLCM_region(k)*log2(Norm_GLCM_region(k));
            end
        end
        Entropy_fet1 = -Ent_int;



%%%%% Feature Sets

F1 = [Energy_fet1 Contr_fet1 Corrla_fet1 Homogen_fet1 Entropy_fet1];

qfeat = [F1 ]';
save qfeat qfeat;

disp('Query Features: ');
disp(qfeat);

warndlg('Feature extraction completed');
guidata(hObject, handles);

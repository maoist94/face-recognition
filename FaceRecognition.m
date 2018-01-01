function FaceRecognition  
clear  % calc xmean,sigma and its eigen decomposition    
close all  
allsamples=[];%??????   
for i=1:40      
    for j=1:5          
        if(i<10)  
           a=imread(strcat('E:\ORL_92x112\00',num2str(i),'0',num2str(j),'.bmp'));       
        else  
            a=imread(strcat('E:\ORL_92x112\0',num2str(i),'0',num2str(j),'.bmp'));    
        end            
        b=a(1:112*92); % b???? 1?N???N?10304?????????????????????          
        b=double(b);          
        allsamples=[allsamples; b];  % allsamples ???M * N ???allsamples ???????????????M?200     
    end  
end  
samplemean=mean(allsamples); % ?????1 ? N    
figure%???  
imshow(mat2gray(reshape(samplemean,112,92)));  
for i=1:200   
    xmean(i,:)=allsamples(i,:)-samplemean; % xmean???M ? N???xmean????????????????-?????   
end;     
% figure%???  
% imshow(mat2gray(reshape(xmean(1,:),112,92)));  
sigma=xmean*xmean';   % M * M ???   
[v,d]=eig(sigma);  
d1=diag(d);   
[d2,index]=sort(d1); %?????   
cols=size(v,2);% ?????????  
  
for i=1:cols        
    vsort(:,i) = v(:, index(cols-i+1) ); % vsort ???M*col(?:col????M)??????????????????,???????????        
    dsort(i)   = d1( index(cols-i+1) );  % dsort ????????????????????   
end  %?????? %????90%???   
dsum = sum(dsort);       
dsum_extract = 0;     
p = 0;       
while( dsum_extract/dsum < 0.9)         
    p = p + 1;            
    dsum_extract = sum(dsort(1:p));       
end  
a=1:1:200;  
for i=1:1:200  
y(i)=sum(dsort(a(1:i)) );  
end  
figure  
y1=ones(1,200);  
plot(a,y/dsum,a,y1*0.9,'linewidth',2);  
grid  
title('?n????????????');  
xlabel('?n????');  
ylabel('????');  
figure  
plot(a,dsort/dsum,'linewidth',2);  
grid  
title('?n????????????');  
xlabel('?n????');  
ylabel('????');  
i=1;  % (????)???????????  
while (i<=p && dsort(i)>0)        
    base(:,i) = dsort(i)^(-1/2) * xmean' * vsort(:,i);   % base?N?p??????dsort(i)^(1/2)??????????????  
      i = i + 1;   
end   % add by wolfsky ???????????????????????,???? M*p ???allcoor    
%   
% for i=1:20  
%   figure%???  
% b=reshape(base(:,i)',112,92);%  
% imshow(mat2gray(b));  
% end  
  
allcoor = allsamples * base; accu = 0;   % ????  
  
for i=1:40       
    for j=6:10 %??40 x 5 ?????           
         if(i<10)  
            if(j<10)  
             a=imread(strcat('E:\ORL_92x112\00',num2str(i),'0',num2str(j),'.bmp'));       
            else  
             a=imread(strcat('E:\ORL_92x112\00',num2str(i),num2str(j),'.bmp'));       
            end  
         else  
             if(j<10)  
             a=imread(strcat('E:\ORL_92x112\0',num2str(i),'0',num2str(j),'.bmp'));       
            else  
             a=imread(strcat('E:\ORL_92x112\0',num2str(i),num2str(j),'.bmp'));       
             end  
        end        
        b=a(1:10304);          
        b=double(b);          
        tcoor= b * base; %??????1?p???        
        for k=1:200                   
            mdist(k)=norm(tcoor-allcoor(k,:));          
        end;          %????     
        [dist,index2]=sort(mdist);            
        class1=floor( index2(1)/5 )+1;        
        class2=floor(index2(2)/5)+1;          
        class3=floor(index2(3)/5)+1;          
        if class1~=class2 && class2~=class3   
            class=class1;           
        elseif class1==class2            
            class=class1;           
        elseif class2==class3       
            class=class2;           
        end;           
        if class==i        
            accu=accu+1;          
        end;     
    end;  
end;    
accuracy=accu/200 %????? 
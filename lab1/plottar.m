Ts=1/8000;
fs=8000;
%% a 
load a_01 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound

%%
load a_02 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound

%%
load o_01 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound

%%
load o_02 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound


%%
load vissel_01 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound

%%
load vissel_02 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

%pre processing
vissel_02_iddata = iddata(y(2,:)',[],1/8000)
vissel_02_iddatae = vissel_02_iddata([11359:26141]);%tabort transienter

figure(10)
plot(vissel_02_iddata)
hold on
plot(vissel_02_iddatae,'r')
hold off
title('Whistle')
xlabel('Tid[s]')
legend('Orginal','Trimmad')
pdf_print('whistle_trim.pdf')

%soundsc(y(2,:),8000) % Listen to the sound

%plotta frekvensspektra för trimmad och otrimmad
figure(11)
plot(chgFreqUnit(fft(vissel_02_iddata),'Hz'))
hold on
plot(chgFreqUnit(fft(vissel_02_iddatae),'Hz'),'r')
hold off
title('Whistle frekvensspektra')
xlabel('Frekvens[Hz]')
legend('Orginal','Trimmad')
pdf_print('whistle_fft.pdf')

%energi-innehåll
U_tot=sum(vissel_02_iddatae.y.^2)
U_tot_f=sum(get(abs(fft(vissel_02_iddatae)),'y').^2)*2
U_tot_f=sum(abs(fft(vissel_02_iddatae.y)).^2)/(2*pi)%TODO 

%bp-filter
figure(12)
vissel_02_iddatae_bp = idfilt(chgFreqUnit(fft(vissel_02_iddatae),'Hz'),[1300 1700])
%plotta frekvensspektra för filtrerad och ofiltrerad
figure(11)
plot(chgFreqUnit(fft(vissel_02_iddatae),'Hz'))
hold on
plot(vissel_02_iddatae_bp,'r')
hold off
title('Whistle frekvensspektra ')
xlabel('Frekvens[Hz]')
legend('Ofiltrerad','Filtrerad')
pdf_print('whistle_filtrerad.pdf')

%energi-innehåll
U_tot_bp=sum(get(ifft(vissel_02_iddatae_bp),y).^2)
U_tot_f_bp=sum(get(abs(vissel_02_iddatae_bp),'y').^2)*2
U_tot_f=sum(abs(fft(vissel_02_iddatae.y)).^2)/(2*pi)%TODO 

%%
load fox_01 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound

%%
load fox_02 % Load data (a_sound <-> name of file)
figure(1)
plot(y(1,:),y(2,:)) % Signal amplitude vs. time
figure(2)
plot(abs(fft(y(2,:))))

soundsc(y(2,:),8000) % Listen to the sound
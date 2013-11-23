load vissel_02
Ts=1/8000;
fs=8000;
%% pre processing
vissel_02_iddata = iddata(y(2,:)',[],Ts)
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

%energi-inneh�ll
U_tot=Ts*sum(vissel_02_iddatae.y.^2)
U_tot_f=Ts*sum(abs(fft(vissel_02_iddatae.y)).^2)/length(vissel_02_iddatae.y)

%% bp-filter
[b,a]=butter(5,[1300*2/fs 1700*2/fs]);
freqz(b,a);
vissel_02_bp = filtfilt(b,a,vissel_02_iddatae.y);
vissel_02_bp_iddata = iddata(vissel_02_bp,[],Ts)

% plotta frekvensspektra för filtrerad och ofiltrerad
figure(11)
plot(chgFreqUnit(fft(vissel_02_iddatae),'Hz'))
hold on
plot(chgFreqUnit(fft(vissel_02_bp_iddata),'Hz'),'r')
hold off
title('Whistle frekvensspektra ')
xlabel('Frekvens[Hz]')
legend('Ofiltrerad','Filtrerad')
pdf_print('whistle_filtrerad.pdf')

%energi-innehåll
U_bp=Ts*sum(vissel_02_bp_iddata.y.^2)
U_bp_f=Ts*sum(abs(fft(vissel_02_bp_iddata.y)).^2)/length(vissel_02_bp_iddata.y) 


%% bp-filter 2
F_lower=1535
F_upper=1545
[b,a]=butter(5,[F_lower*2/fs F_upper*2/fs]);
figure(20)
freqz(b,a);
pdf_print('whistle_filter_response.pdf')

vissel_02_bp = filtfilt(b,a,vissel_02_iddatae.y);
vissel_02_bp_iddata = iddata(vissel_02_bp,[],Ts)

% plotta frekvensspektra för filtrerad och ofiltrerad
figure(21)
plot(chgFreqUnit(fft(vissel_02_iddatae),'Hz'))
hold on
plot(chgFreqUnit(fft(vissel_02_bp_iddata),'Hz'),'r')
hold off
title('Whistle frekvensspektra ')
xlabel('Frekvens[Hz]')
legend('Ofiltrerad','Filtrerad')
pdf_print('whistle_filtrerad_1535_1545.pdf')

%energi-innehåll
U_bp=Ts*sum(vissel_02_bp_iddata.y.^2)
U_bp_f=Ts*sum(abs(fft(vissel_02_bp_iddata.y)).^2)/length(vissel_02_bp_iddata.y) 

sig=fft(vissel_02_iddatae.y);
%sig=sig.y;

figure(100)
plot(abs(sig))

U_bp_f_strict=Ts*sum(abs(sig(floor(F_lower/(fs/length(vissel_02_iddatae.y))):floor(F_upper/(fs/length(vissel_02_iddatae.y))))).^2)/length(vissel_02_iddatae.y)*2 % times 2 because we are using only half the spectra to calc the enegy


harmonic_distorsion=1-U_bp/U_tot
harmonic_distorsion_strict=1-U_bp_f_strict/U_tot
%% AR
figure(13)
arx_rm_trans_bp = arx(vissel_02_bp_iddata,[2], arxOptions);
arx_org = arx(vissel_02_iddatae,[2], arxOptions);

pzmap(arx_rm_trans_bp,arx_org)
title('Pol/nollställe-diagram')
ylabel('Imaginäraxel')
xlabel('Realaxel')
legend('Filtrerad','Ofiltrerad')
pdf_print('whistle_pz_map.pdf')

%avstånd till enhetscirkeln
dist_roots_bp=1-abs(roots(arx_rm_trans_bp.a))
dist_roots_org=1-abs(roots(arx_org.a))

e = randn(1,length(vissel_02_bp_iddata.y));
yhat = filter(1,arx_rm_trans_bp.a,e);

skalfaktor=1/195

yhat_iddata=iddata(yhat'.*skalfaktor,[],Ts);
%soundsc(yhat,8000)
%soundsc(vissel_02_bp_iddata.y,8000)

figure(16)
plot(chgFreqUnit(fft(vissel_02_bp_iddata),'Hz'))
hold on
plot(chgFreqUnit(fft(yhat_iddata),'Hz'),'r')
hold off
title('Whistle frekvensspektra ')
xlabel('Frekvens[Hz]')
legend('Verklig','Modell')
pdf_print('whistle_fft_skattad.pdf')


%% non-parametric and parametric upg5
figure(14)
etf50 = etfe(vissel_02_iddatae,[],50);
plot(etf50)

pdf_print('whistle_etf50.pdf')

figure(15)
h=bodeplot(arx_org)
setoptions(h,'FreqUnits','Hz');

pdf_print('whistle_bode_ar2.pdf')
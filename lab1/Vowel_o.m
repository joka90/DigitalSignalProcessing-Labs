load o_02
Ts=1/8000;
fs=8000;

%% pre processing
o_02_iddata = iddata(y(2,:)',[],Ts);
o_02_iddata_detrend=detrend(o_02_iddata,0);

%lp-filter
F_cuttoff=1000
[b,a]=butter(5,F_cuttoff*2/fs);

o_02_lp = filtfilt(b,a,o_02_iddata_detrend.y);
o_02_lp_iddata = iddata(o_02_lp,[],Ts)

o_02_iddata_valid = o_02_lp_iddata([20092:31760]);
o_02_iddata_estim = o_02_lp_iddata([7734:19922]);

figure(30)
plot(o_02_lp_iddata,'b',o_02_iddata_estim,'y',o_02_iddata_valid,'r')

title('Vowel för o')
xlabel('Tid[s]')
legend('Orginal','Valideringsdata','Estimeringsdata')
pdf_print('vowel_trim_o.pdf')

%plotta frekvensspektra för de olika delarna
figure(31)
plot(chgFreqUnit(fft(o_02_iddata_detrend),'Hz'),'b',chgFreqUnit(fft(o_02_iddata_estim),'Hz'),'y',chgFreqUnit(fft(o_02_iddata_valid),'Hz'),'r')
title('Vowel frekvensspektra för o')
legend('Orginal','Valideringsdata','Estimeringsdata')
%axis([0 1600 0 3.5])
xlabel('Frekvens[Hz]')
pdf_print('vowel_fft_o.pdf')



%% AR-modeller
ar30=ar(o_02_iddata_estim,30);
ar20=ar(o_02_iddata_estim,20);
ar16=ar(o_02_iddata_estim,16);
ar14=ar(o_02_iddata_estim,14);
ar12=ar(o_02_iddata_estim,12);
ar10=ar(o_02_iddata_estim,10);
ar8=ar(o_02_iddata_estim,8);
ar6=ar(o_02_iddata_estim,6);

Ne=length(o_02_iddata_estim.y);
est_diag=[...
sum(pe(ar6,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar8,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar10,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar12,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar14,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar16,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar20,o_02_iddata_estim.y).^2)/Ne
sum(pe(ar30,o_02_iddata_estim.y).^2)/Ne];

valid_diag=[...
sum(pe(ar6,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar8,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar10,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar12,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar14,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar16,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar20,o_02_iddata_valid.y).^2)/Ne
sum(pe(ar30,o_02_iddata_valid.y).^2)/Ne];

prederr(ar30,o_02_iddata_valid.y)
[err,x0e,sys_pred] = pe(o_02_iddata_valid,ar30)

model_order=[6 8 10 12 14 16 20 30];
figure(40)
plot(model_order,est_diag','-',model_order,valid_diag','--')

%%
figure(32)
pzmap(ar12)
title('Pool/nollställediagram för o')
pdf_print('vowel_pzmap_o_ar12.pdf')

opt = compareOptions;
figure(33)
[y,fit,x0] =compare(o_02_iddata_valid,ar30,ar20,ar16,ar14,ar12,ar10,ar8,ar6,5,opt);

[model_order(end:-1:1)']
fit

%pdf_print('vowel_compare_o.pdf')

%resid(o_02_iddata_valid,ar20,'Corr')


%% spela modell
%Use the signal period as pulse interval.
%% generera pulståg
f=101.2%o grundton = 101.2 hz
%f=110.7%a grundton = 110.7 hz
sampleperiod=1/(f*Ts)
u=[1 zeros(1,floor(sampleperiod)-1)];
for i=0:7;
   u=[u u];
end

%plot(abs(fft(u)))

%% spela upp
yhat = filter(1,ar12.a,u);

yhat_skal=sum(yhat.^2)/length(yhat);
estim_skal=sum(o_02_iddata_estim.y.^2)/length(o_02_iddata_estim.y);

skalfaktor=sqrt(yhat_skal/estim_skal)
%soundsc(yhat,fs)
%%
yhat_iddata = iddata(2.8e-5.*yhat',[],Ts);
figure(34)
plot(chgFreqUnit(fft(o_02_iddata_estim),'Hz'),'b',chgFreqUnit(fft(yhat_iddata),'Hz'),'r')
title('Vowel frekvensspektra för o, modell vs. verklighet')
legend('Verklighet','Modell')
axis([0 1000 0 25])
pdf_print('vowel_model_o.pdf')
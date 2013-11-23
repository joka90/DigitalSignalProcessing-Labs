load a_02
Ts=1/8000;
fs=8000;

%% pre processing
a_02_iddata = iddata(y(2,:)',[],Ts);
a_02_iddata_detrend=detrend(a_02_iddata,0)
a_02_iddata_valid = a_02_iddata_detrend([16484:31766]);
a_02_iddata_estim = a_02_iddata_detrend([3640:16360]);

figure(30)
plot(a_02_iddata_detrend,'b',a_02_iddata_estim,'y',a_02_iddata_valid,'r')

title('Vowel')
xlabel('Tid[s]')
legend('Orginal','Valideringsdata','Estimeringsdata')
pdf_print('vowel_trim.pdf')

%plotta frekvensspektra för de olika delarna
figure(31)
plot(chgFreqUnit(fft(a_02_iddata_detrend),'Hz'),'b',chgFreqUnit(fft(a_02_iddata_estim),'Hz'),'y',chgFreqUnit(fft(a_02_iddata_valid),'Hz'),'r')
title('Vowel frekvensspektra')
legend('Orginal','Valideringsdata','Estimeringsdata')
%axis([0 1600 0 3.5])
xlabel('Frekvens[Hz]')
pdf_print('vowel_fft.pdf')



%% AR-modeller
ar30=ar(a_02_iddata_estim,30);
ar20=ar(a_02_iddata_estim,20);
ar16=ar(a_02_iddata_estim,16);
ar14=ar(a_02_iddata_estim,14);
ar12=ar(a_02_iddata_estim,12);
ar10=ar(a_02_iddata_estim,10);
ar8=ar(a_02_iddata_estim,8);

figure(36)
pzmap(ar14)
opt = compareOptions;
figure(32)
compare(a_02_iddata_valid,ar30,ar20,ar16,ar14,ar12,ar10,ar8,5,opt)

%% spela modell
%Use the signal period as pulse interval.
%% generera pulståg
f=101.2%o grundton = 101.2 hz
f=110.7%a grundton = 110.7 hz
sampleperiod=1/(f*Ts)
u=[1 zeros(1,floor(sampleperiod)-1)];
for i=0:7;
   u=[u u];
end

%plot(abs(fft(u)))

%% spela upp
yhat = filter(1,ar16.a,u);

yhat_skal=sum(yhat.^2);
estim_skal=sum(a_02_iddata_estim.y.^2);

skalfaktor=yhat_skal/estim_skal

soundsc(yhat,fs)
%%
yhat_iddata = iddata(skalfaktor.*yhat',[],Ts);
plot(chgFreqUnit(fft(a_02_iddata_estim),'Hz'),'y',chgFreqUnit(fft(yhat_iddata),'Hz'),'r')
title('Vowel frekvensspektra, modell vs. verklighet')
legend('Verklighet','Modell')
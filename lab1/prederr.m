function [varians] = prederr(sys,validdata)
y=sim(sys,[zeros(size(validdata))])
varians=var(y-validdata);
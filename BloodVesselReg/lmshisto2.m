% Function that calulates the LMS of the histogram (histo)
% within a especific range percentage.
% Returns the LMS (LEAST MEDIAN OF SQUARES) and the
% respective robust standard deviation.
% Ref: Rousseeuw, P. Robust Regression and Outlier Detection, 1987.
%
% Function written by M. Elena Martinez-Perez, (1999)
% National Autonomous University of Mexico, UNAM
%
%[mode,sigma]=lmshisto2(histo,percentage)
% 

function [mode,sigma]=lmshisto2(histo,percentage)

  % Number of elementes in the histogram
  n=sum(histo);

  h=(n*percentage)/100.0;
  menor=50000.0;

  % Find the first element of the array 
  % different than zero
  ii=find(histo>0);
  i=ii(1);
  clear ii;

  % Find the first valid interval
  suma=0;
  j=i;
  while(suma<h)
    suma=suma+histo(j);
    j=j+1;
  end;

  dif = (j-1)-i;
  if (dif < menor)  % ojo <= 
    menor=dif;
    m=i;
  end;
  histo(i)=histo(i)-1;

  % Find the rest of the intervals until it finishes
  k=2;
  while(k<h)

    while(histo(i)==0)
      i=i+1;
    end;
         
    suma=sum(histo(i:j-1));
   
    if (suma<h)
      j=j+1;
    else
      dif = (j-1)-i;
      if (dif < menor)  % ojo <= 
        menor=dif;
        m=i;
      end;
    end;

    histo(i)=histo(i)-1;
    k=k+1;    
  end;

  % Look for the median of the shortest interval
  % change to corresponding gray value of the
  % histogram
  mode = m + (menor/2.0);

  % To compute the robust standard deviation

  switch (percentage)
     case 20,
          sigma= 3.9215 * (menor/2.0);   % .20  
	  
     case 25,
	       sigma= 3.1746 * (menor/2.0);   % .25
	  
     case 30,
	       sigma= 2.5974 * (menor/2.0);   % .30  
	  
     case 35,
	       sigma= 2.1978 * (menor/2.0);   % .35 
	  
     case 40,
	       sigma= 1.8975 * (menor/2.0);   % .40  
	  
     case 45,
	       sigma= 1.6666 * (menor/2.0);   % .45 
	  
     case 50,
	       sigma= 1.4826 * (menor/2.0);   % .50  
	  
  end;











function TellMe(formatvar,stringvar,speakvar)

%	This function uses tts to speak out the stringvar if speaktovar is set, else fprintfs it to cmd window
%	TellMe(formatvar,stringvar,speakvar)

if speakvar==1
    tts(stringvar);
else
    fprintf(formatvar,stringvar);
end
P. Goodwin. Code for Continental breakup–driven uplift instigated East Antarctic Ice Sheet formation (2026)
The two Matlab code files perform the Antarctic Glaciation experiments in Gernon, T., Hincks, T., Goodwin, P., Paxman, G.J.G., Brune, S., Rohling, E.J., Keir, D. and Braun, J. (2026). 
Model code by P. Goodwin. 
The file "EBM_AAGlaciation_final_published_code.m" contains the main Energy Balance Model, 
while the file "Load_Data_EBM.m" contains 
Put both Matlab code files in the same folder. Open Matlab and navigate to that folder.
Run the model by entering "EBM_AAGlaciation_final_published_code" into the matlab window. 
The code will run and produce a table of values corresponding to equilibrated climate states 
separated by incremental uniform radiative forcing.
The code as provided will run the model with Antarctic land elevations of 34Ma. 
To simulate other land elevation periods, edit the "Load_Data_EBM.m" file to comment out
the 34Ma parameters and comment in the required elevation time periods. Then edit the 
"EBM_AAGlaciation_final_published_code.m" file to change any parameters with 34Ma in the name
to match the required time periods from the "Load_Data_EBM.m" file.

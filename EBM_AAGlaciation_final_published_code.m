%Energy Balance model with latitude-varying cloud albedo, temperature sensitive surface albedo, and temperature-sensitive emissivity (WVLR feedback).



Results_table_Antarctica  = table ([0;0;0], [0;0;0], [0;0;0], [0;0;0],[0;0;0],[0;0;0], [0;0;0], [0;0;0], [0;0;0], [0;0;0],[0;0;0], [0;0;0], [0;0;0], [0;0;0], 'VariableNames', {'PercentageElevation', 'RadiativeForcing', 'AntarcticTemperature', 'GlobalMeanWarming', 'AntarcticElevation', 'IceSheetThickness', 'Antarctic_geoHeight', 'IceSheetThickness80', 'Percentage_Area_IceSheet_82', 'GlobalMeanT', 'LTG', 'SO_Temp', 'Low_Lat_Temp', 'Northern_Temp'})

Table_row = 0;

Table_row_Antarctica = 0;

for PAE = 1:1
    for RFU = 1:51

        Load_Data_EBM;

        Table_row_Antarctica = Table_row_Antarctica + 1



Percentage_Antarctica_elevation = 105.0 - 5.0*PAE; %20.0; %0 = sea level, 100 = modern day elevation
Radiative_forcing_uniform = 0 + 0.4*(RFU - 1); %0.0; %0.0 is modern, -ve values are cooler, +ve values are warmer.

Antarctic_ice_sheet_elevation = linspace(0.0, 0.0, 180);
[~, size_85_90S] = size(alt_85_90S);
[~, size_80_85S] = size(alt_80_85S);
[~, size_75_80S] = size(alt_75_80S);
Antarctic_ice_sheet_elevation_85_90S = zeros([5, size_85_90S]);
Antarctic_ice_sheet_elevation_80_85S = zeros([5, size_80_85S]);
Antarctic_ice_sheet_elevation_75_80S = zeros([5, size_75_80S]);

T_adjusted_85_90S = zeros(size_85_90S);
T_adjusted_80_85S = zeros(size_80_85S);
T_adjusted_75_80S = zeros(size_75_80S);


%Assume linear relation between T and ice sheet thickness between limits

Antarctic_ice_sheet_maxT = Annual_T_obs(24); %K, maximum temperature at which ice sheet can form
Antarctic_ice_sheet_minT = Annual_T_obs(1:23) + 1.0; %Gets to current size X degrees above current T %230.0; %K, minimum temperature below which ice sheet will not increase in thickness


%Define the turning points for the temperature-surface albedo link
T_cold=243.15;
T_warm=273.15-5.0;
alpha_mean_cold = 0.45;
alpha_mean_warm = 0.17;

%Determined using erf() fit to 1degree x 1 degree data 2003-2023, alpha values refer to global mean for that surface-type (latitudinal effect removed).
alpha_cold_land = 0.607;
alpha_warm_land = 0.200;
T_cold_land = 252.2;
T_warm_land = 267.5;

alpha_cold_ocean = 0.607;
alpha_warm_ocean = 0.1155;
T_cold_ocean = 252.02;
T_warm_ocean = 273.88;

beta_ClearSky = 0.33;

%funct of this form: alpha_mean_erf(i) = (alpha_mean_warm + alpha_mean_cold)/2.0 - ((alpha_mean_cold - alpha_mean_warm)/2.0)*erf( (Ts(i) - (T_cold + T_warm)/2.0)/((T_warm - T_cold)/2.0)) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%land frac at 1 degree resolution %%%%%%%%%%%%%%%%%%%%%%
land_frac=[1    1    1    1    1    1    1    1    1    1    1    1    0.911111111    0.827777778    0.794444444    0.741666667    0.694444444    0.636111111    0.572222222    0.538888889    0.444444444    0.352777778    0.288888889    0.225    0.069444444    0.025    0.022222222    0.016666667    0.011111111    0.005555556    0.005555556    0.002777778    0.002777778    0.002777778    0.013888889    0.044444444    0.025    0.033333333    0.036111111    0.027777778    0.033333333    0.033333333    0.036111111    0.052777778    0.044444444    0.047222222    0.058333333    0.055555556    0.061111111    0.063888889    0.058333333    0.080555556    0.097222222    0.097222222    0.097222222    0.144444444    0.166666667    0.183333333    0.205555556    0.208333333    0.222222222    0.222841226    0.233333333    0.227777778    0.247222222    0.258333333    0.261111111    0.269444444    0.288888889    0.275    0.266666667    0.266666667    0.275    0.275    0.266666667    0.263888889    0.247222222    0.233333333    0.227777778    0.247222222    0.261111111    0.311111111    0.305555556    0.294444444    0.3    0.3    0.322222222    0.322222222    0.305555556    0.286111111    0.269444444    0.261111111    0.25    0.236111111    0.255555556    0.272222222    0.280555556    0.280555556    0.297222222    0.3    0.3    0.288888889    0.288888889    0.286111111    0.3    0.311111111    0.322222222    0.338888889    0.394444444    0.355555556    0.375    0.416666667    0.4    0.391666667    0.408333333    0.416666667    0.427777778    0.441666667    0.455555556    0.459610028    0.472222222    0.466666667    0.455555556    0.447222222    0.466666667    0.480555556    0.502777778    0.488764045    0.476056338    0.487323944    0.507002801    0.504225352    0.505617978    0.535211268    0.550561798    0.544159544    0.565714286    0.579545455    0.591549296    0.613888889    0.622222222    0.661111111    0.677777778    0.655555556    0.655555556    0.622222222    0.6    0.602777778    0.613888889    0.675    0.733333333    0.736111111    0.780555556    0.805555556    0.830555556    0.863888889    0.855555556    0.819444444    0.813888889    0.758333333    0.625    0.525    0.447222222    0.386111111    0.358333333    0.402777778    0.380555556    0.319444444    0.325    0.325    0.358333333    0.283333333    0.188888889    0.088888889    0    0    0    0    0    0];


%Coefficients for epsilon function - spatial 1degx1deg values then used as
%starting values for zonal-mean analysis. These are the final zonal mean
%values, R^2 = 0.929
c0 = 1.76268303394318e+00;  %1.762682989353691e+00;
c1 = -3.06870625354350e-03; %-2.934625328677953e-03;
c2 = -2.07908073207363e-04; %-2.079080706398782e-04;
c3 = -1.35601089823467e-06; %-8.801418440872719e-07;
c4 = -3.19683109410107e-03; %-3.196831093031486e-03;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi_deg = linspace(-89.5, 89.5, (180/1));
phi_rad = (pi()/180)* phi_deg;

[~, size_array] = size(phi_rad)
phi_deg_between = linspace(0, 0, size_array -1);
phi_rad_between = linspace(0, 0, size_array -1);
for i=1:size_array-1
    phi_deg_between(i) = phi_deg(i)+0.5*180/size_array;
    phi_rad_between(i) = deg2rad(phi_deg_between(i));
end



S_in = S_in_obs;

S_in_start = S_in;



dt =60*60 ; %60*60*24; %time-step (1 'day', note there is no seasonality in the model)

R_Earth = 6371000.0 % Radius of Planet earth in m
Area_Earth = 4*pi()*R_Earth^2;



Length_phi = linspace(0,0,size_array-1);
for i=1:size_array-1
    Length_phi(i) = 2*pi()*R_Earth * cos(phi_rad_between(i)) ; %cos(phi_rad(i)+0.5*pi()/size_array); %length of line of latitude mid way between the points
end

Area = 0.5*Area_Earth * ( (1-sin(phi_rad-0.5*pi()/size_array)) - (1-sin(phi_rad+0.5*pi()/size_array)) ); %Areas of latitudinal bands

Area_between = 0.5*Area_Earth * ( (1-sin(phi_rad_between-0.5*pi()/size_array)) - (1-sin(phi_rad_between+0.5*pi()/size_array)) ); 

sigma = 5.67e-8; %Stephan-Botlzmann constant in kg s^-3 K^-4

Annual_T_obs_interp = linspace(0,0,size_array-1);

for(i=1:size_array-1)
    Annual_T_obs_interp(i) = 0.5*(Annual_T_obs(i) + Annual_T_obs(i+1));
end
Cloud_Amount_obs = 0.01*Cloud_Amount_obs;
Cloud_insolation_fraction_obs = 0.01*Cloud_insolation_fraction_obs;

Cloud_Amount = Cloud_Amount_obs;
Cloud_insolation_fraction = Cloud_insolation_fraction_obs;

epsilon_AllSky_obs = L_out_obs./(sigma*Annual_T4_obs);
alpha_AllSky_obs = S_out_obs./S_in;

epsilon_ClearSky_obs = L_out_ClearSky_obs./(sigma*Annual_T4_obs);
alpha_ClearSky_obs = S_out_ClearSky_obs./S_in;

epsilon_CloudySky_obs = (1./Cloud_Amount_obs).* (epsilon_AllSky_obs - (1-Cloud_Amount_obs).*epsilon_ClearSky_obs );

c_epsilonCloudy = (1-epsilon_CloudySky_obs)./(1-epsilon_ClearSky_obs);

c_epsilonCloudy_obs = c_epsilonCloudy;

alpha_CloudySky_obs = (1./Cloud_insolation_fraction).*(alpha_AllSky_obs - (1-Cloud_insolation_fraction).*alpha_ClearSky_obs);


Coefficients_linear = polyfit(Annual_T_obs, epsilon_ClearSky_obs,1);


%alpha_Cloud_obs = linspace(0.0,0.0,size_array);

Mean_c_epsilonCloudy = sum(c_epsilonCloudy.*Area)/sum(Area);

%Set heat capacities%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c_p = 3.910e3; %Ocean mean heat capacity in J kg-1 K-1 (Williams et al., 2012)

Mass_ocean = 1027.0*sum(Area)*0.7*(2400-150); %Gregory (2000) depth of 2400m for lower ocean (ignores deep isolated basins) %1.35e21; % actual mass of ocean in kg

c_per_m2 = 0.7*150*c_p*1027.0; % Heat capacity of surface per metre squared (atmosphere plus ocean surface mixed layer) - 70% ocean coverage with 150m deep surface-ocean mixed layer. Ocean mixed layer dominated.

c = c_per_m2 * Area; %Heat capacity of each latitudinal band

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%Set diffusivity

kappa_poleward = linspace(90.0, 90.0, size_array-1); %horizontal poleward heat transport diffusivity in W per °C per m^2


alpha = linspace(0.3,0.3,size_array);

%declare initial surface temperature and northward heat trasport%%%%%%%%%%%%%
T_surface = linspace(273.15, 273.15, size_array);
Northward_Heat_Transport = linspace(0.0,0.0, size_array-1);

%Set initial clear sky emissivity, allsky emissivity, outgoing longwave and outgoing shortwave %%%%%%%%
epsilon_Clear_Sky_calc = 1.82785897 - 3.95009011e-03*T_surface;
epsilon_Cloudy_calc = 1-c_epsilonCloudy.*(1-epsilon_Clear_Sky_calc);
epsilon = Cloud_Amount.*epsilon_Cloudy_calc + (1-Cloud_Amount).*epsilon_Clear_Sky_calc; %1-1.3*(1-epsilon_Clear_Sky_calc);
L_out = sigma*epsilon.*(T_surface.^4);
S_out =alpha.*S_in;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean_epsilon = sum(epsilon_AllSky_obs.*Area)/sum(Area);

%%Set diffusivity%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kappa_poleward_obs = linspace(0,0,size_array-1);
%for i=1:size_array-1
%    kappa_poleward_obs(i) = - Northward_heat_flux_obs(i) /  ( (pi()*R_Earth/size_array)*(Annual_T_obs(i+1)-Annual_T_obs(i))*Length_phi(i) );
%end

f_NHT_obs = Northward_heat_flux_obs./Length_phi;

kappa_poleward_obs=[2.91257E+11	6.10906E+11	1.02411E+12	1.55658E+12	2.25719E+12	3.26741E+12	5.21673E+12	8.24063E+12	1.13753E+13	1.12945E+13	8.96249E+12	7.24815E+12	6.12685E+12	5.3591E+12	4.9728E+12	4.82626E+12	4.81224E+12	4.85414E+12	4.99278E+12	5.25261E+12	5.697E+12	6.34375E+12	7.24223E+12	8.37368E+12	9.87178E+12	1.18903E+13	1.44515E+13	1.7155E+13	1.9513E+13	2.18016E+13	2.43033E+13	2.66107E+13	2.861E+13	3.03443E+13	3.17198E+13	3.25922E+13	3.2905E+13	3.27093E+13	3.21351E+13	3.13948E+13	3.05711E+13	2.96342E+13	2.87825E+13	2.81082E+13	2.7525E+13	2.7161E+13	2.71056E+13	2.73937E+13	2.79304E+13	2.87161E+13	2.97263E+13	3.09249E+13	3.21975E+13	3.3438E+13	3.40785E+13	3.43346E+13	3.45158E+13	3.49033E+13	3.54066E+13	3.56117E+13	3.57068E+13	3.6121E+13	3.69701E+13	3.80507E+13	3.91887E+13	4.05263E+13	4.1946E+13	4.36892E+13	4.55941E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.65983E+13	4.50707E+13	4.09207E+13	3.53411E+13	3.05731E+13	2.71881E+13	2.52459E+13	2.37938E+13	2.24233E+13	2.17117E+13	2.14819E+13	2.28682E+13	2.51303E+13	2.71674E+13	2.98554E+13	3.23914E+13	3.38067E+13	3.3895E+13	3.32997E+13	3.21631E+13	2.96549E+13	2.78222E+13	2.69497E+13	2.64296E+13	2.69321E+13	2.80467E+13	2.89871E+13	2.99101E+13	3.19596E+13	3.51875E+13	3.87982E+13	4.1352E+13	4.33539E+13	4.44802E+13	4.30616E+13	3.81106E+13	3.25877E+13	2.8447E+13	2.54232E+13	2.31364E+13	2.16069E+13	2.05553E+13	2.00104E+13	2.02928E+13	2.13075E+13	2.26623E+13	2.3732E+13	2.47656E+13	2.63422E+13	2.7415E+13	2.77812E+13	2.78314E+13	2.6422E+13	2.4089E+13	2.23383E+13	2.18608E+13	2.18459E+13	2.19914E+13	2.45935E+13	2.88108E+13	3.42452E+13	4.47992E+13	6.31506E+13	8.0595E+13	8.83821E+13	8.27246E+13	6.13183E+13	2.80808E+13	1.7191E+13	];

kappa_poleward = linspace(100.0, 100.0, size_array-1); %horizontal poleward heat transport diffusivity in W per °C per m^2



%for i=1:size_array-1
%    if(kappa_poleward_obs(i) > 0.0)
%        kappa_poleward(i) = kappa_poleward_obs(i);
%    end
%    if(kappa_poleward_obs(i) < 0.0)
%        kappa_poleward(i) = kappa_poleward(i-1);
%    end
    %if(kappa_poleward(i) > 200.0)
    %    kappa_poleward(i) = 200.0;
    %end

%end

%Initial 
%kappa_poleward=[	3E+11	1.23235E+12	2.16471E+12	3.09706E+12	4.02941E+12	4.96176E+12	5.89412E+12	6.82647E+12	7.75882E+12	8.69118E+12	9.62353E+12	1.05559E+13	1.14882E+13	1.24206E+13	1.33529E+13	1.42853E+13	1.52176E+13	1.615E+13	1.70824E+13	1.80147E+13	1.89471E+13	1.98794E+13	2.08118E+13	2.17441E+13	2.26765E+13	2.36088E+13	2.45412E+13	2.54735E+13	2.64059E+13	2.73382E+13	2.82706E+13	2.92029E+13	3.01353E+13	3.10676E+13	3.2E+13	3.22941E+13	3.25882E+13	3.28824E+13	3.31765E+13	3.34706E+13	3.37647E+13	3.40588E+13	3.43529E+13	3.46471E+13	3.49412E+13	3.52353E+13	3.55294E+13	3.58235E+13	3.61176E+13	3.64118E+13	3.67059E+13	3.7E+13	3.72941E+13	3.75882E+13	3.78824E+13	3.81765E+13	3.84706E+13	3.87647E+13	3.90588E+13	3.93529E+13	3.96471E+13	3.99412E+13	4.02353E+13	4.05294E+13	4.08235E+13	4.11176E+13	4.14118E+13	4.17059E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.2E+13	4.17059E+13	4.14118E+13	4.11176E+13	4.08235E+13	4.05294E+13	4.02353E+13	3.99412E+13	3.96471E+13	3.93529E+13	3.90588E+13	3.87647E+13	3.84706E+13	3.81765E+13	3.78824E+13	3.75882E+13	3.72941E+13	3.7E+13	3.67059E+13	3.64118E+13	3.61176E+13	3.58235E+13	3.55294E+13	3.52353E+13	3.49412E+13	3.46471E+13	3.43529E+13	3.40588E+13	3.37647E+13	3.34706E+13	3.31765E+13	3.28824E+13	3.25882E+13	3.22941E+13	3.2E+13	3.17059E+13	3.14118E+13	3.11176E+13	3.08235E+13	3.05294E+13	3.02353E+13	2.99412E+13	2.96471E+13	2.93529E+13	2.90588E+13	2.87647E+13	2.84706E+13	2.81765E+13	2.78824E+13	2.75882E+13	2.72941E+13	2.7E+13	2.67059E+13	2.64118E+13	2.61176E+13	2.58235E+13	2.55294E+13	2.52353E+13	2.49412E+13	2.46471E+13	2.43529E+13	2.40588E+13	2.37647E+13	2.34706E+13	2.31765E+13	2.28824E+13	2.25882E+13	2.22941E+13	2.2E+13	];

kappa_poleward =kappa_poleward_obs;
kappa_standard = kappa_poleward;
kappa_excluding_tropics = [kappa_standard(1:16), kappa_standard(22:35)];
T_exluding_tropics = [Annual_T_obs(1:16), Annual_T_obs(22:35)];
Coeff_kappa_T_extratropics = polyfit(T_exluding_tropics,kappa_excluding_tropics, 1);

kappa_poleward_mean = sum(kappa_poleward_obs.*Area_between)/sum(Area_between);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%definition of radiative forcing
RF = linspace(0.0, 0.0, size_array) + Radiative_forcing_uniform*linspace(1.0, 1.0, size_array);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Code for adjusting T and pressure if surface elevation changes
%coefficients
dp_dz = -10775; %Pa per km
dT_dz = -6.5; %K per km lapse rate
Elevation_adjusted = Elevation_GMTED2010; %Set up an alternative elevation


%Calculate Antarctic ice sheet max
for i=1:5
    Elevation_adjusted(i) = 100*mean_elevation_85_90S_34Ma/100; 
    Antarctic_ice_sheet_elevation_max(i) = Elevation_GMTED2010(i) - Elevation_adjusted(i);
    for j1=1:size_85_90S
        Antarctic_ice_sheet_elevation_max_85_90S(i,j1) = Elevation_GMTED2010(i) - alt_85_90S(j1);
        if(Antarctic_ice_sheet_elevation_max_85_90S(i,j1) < 0.0)
            Antarctic_ice_sheet_elevation_max_85_90S(i,j1) = 0.001*1.0;
        end
    end
end
for i=6:10
    Elevation_adjusted(i) = 100*mean_elevation_80_85S_34Ma/100;
    Antarctic_ice_sheet_elevation_max(i) = Elevation_GMTED2010(i) - Elevation_adjusted(i);
    for j1=1:size_80_85S
        Antarctic_ice_sheet_elevation_max_80_85S(i-5,j1) = Elevation_GMTED2010(i) - alt_80_85S(j1);
        if(Antarctic_ice_sheet_elevation_max_80_85S(i-5,j1) < 0.0)
            Antarctic_ice_sheet_elevation_max_80_85S(i-5,j1) = 0.001*1.0;
        end
    end
end
for i=11:15
    Elevation_adjusted(i) = 100*mean_elevation_75_80S_34Ma/100;
    Antarctic_ice_sheet_elevation_max(i) = Elevation_GMTED2010(i) - Elevation_adjusted(i);
    for j1=1:size_75_80S
        Antarctic_ice_sheet_elevation_max_75_80S(i-10,j1) = Elevation_GMTED2010(i) - alt_75_80S(j1);
        if(Antarctic_ice_sheet_elevation_max_75_80S(i-10,j1) < 0.0)
            Antarctic_ice_sheet_elevation_max_75_80S(i-10,j1) = 0.001*1.0;
        end
    end
end
for i=16:23
    Elevation_adjusted(i) = 100*Elevation_GMTED2010(i)*(mean_elevation_75_80S_34Ma/Elevation_GMTED2010(15))/100; %same fraction of current elevation
    Antarctic_ice_sheet_elevation_max(i) = Elevation_GMTED2010(i) - Elevation_adjusted(i);
end

%Calculate Adjusted elevation for the Percentage Antarctic_elevation
for i=1:5
    Elevation_adjusted(i) = Percentage_Antarctica_elevation*mean_elevation_85_90S_34Ma/100; 
end
for i=6:10
    Elevation_adjusted(i) = Percentage_Antarctica_elevation*mean_elevation_80_85S_34Ma/100;
end
for i=11:15
    Elevation_adjusted(i) = Percentage_Antarctica_elevation*mean_elevation_75_80S_34Ma/100;
end
for i=16:23
    Elevation_adjusted(i) = Percentage_Antarctica_elevation*Elevation_GMTED2010(i)*(mean_elevation_75_80S_34Ma/Elevation_GMTED2010(15))/100; %same fraction of current elevation
end


Pressure_adjusted = Pressure_ERA5 + dp_dz * (Elevation_adjusted - Elevation_GMTED2010); %The pressure at the new elevation
T_adjusted = T_surface + dT_dz * (Elevation_adjusted - Elevation_GMTED2010); %The temperature at the new elevation



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = 2.5e6; %J/kg latent heat water vapour
R_v = 461.0; %gas constant for water vapour in J per K per kg
T = linspace(200,320); %
c_p_dryair = 3910; %specific heat capacity of air J per K per kg
H_rel = 0.7;

qstar = 0.6*6.11*exp((L/R_v)*((1/273) - (1./Annual_T_obs_interp)));

dqstar_dT = ((0.6*6.11*L)./(R_v.*Annual_T_obs_interp.*Annual_T_obs_interp)) .* exp((L/R_v)*((1/273) - (1./Annual_T_obs_interp)));

r_latent_dry = (H_rel*L)/(1000*c_p_dryair) *dqstar_dT;

dr_ld_dT = (H_rel*L)/(1000*c_p_dryair) * (0.6*6.11*L)./(R_v*Annual_T_obs_interp.*Annual_T_obs_interp.*Annual_T_obs_interp).*exp((L/R_v)*((1/273) - (1./Annual_T_obs_interp))).*((L./(R_v*Annual_T_obs_interp)) - 2);

kappa_init = kappa_poleward_obs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%attempt = 0.5;
%for i=1:size_array
%    for j=1:100 %n-step iteration
%        alpha_cloud_attempt = attempt + alpha_ClearSky_obs(i)*(1-attempt)*(1-attempt*attempt);
%        attempt = attempt + (alpha_CloudySky_obs(i) - alpha_cloud_attempt)/2.0;
%    end
%    alpha_Cloud_obs(i) = attempt;
%    attempt = 0.5;
%end




%%%Contact with deep ocean%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gamma_phi = linspace(0.0,0.0,size_array); %Wm-2K-1 from upwelling water
gamma = 1.6 ; %Wm-2K-1 global mean%%%%%%%
Area_upwelling = 0.0;
for(i=1:size_array)
    if(phi_deg(i) < -50.0 & phi_deg(i) > -70.0)
        Area_upwelling = Area_upwelling + Area(i);
    end
end

%62.5 per cent of sub-surface water next makes contact with surface mixed layer in Southern Ocean, 50 to 70 ° South (DeVries and Primeau, 2011)
gamma_upwellSO = 0.625*gamma*sum(Area)/Area_upwelling;
gamma_upwell_rest = (1-0.625)*gamma*sum(Area)/(sum(Area)-Area_upwelling);


DeltaT_deepocean = 0.0;

for i=1:size_array
    if (phi_deg(i) < -50.0 & phi_deg(i) > -70.0)
        gamma_phi(i) = gamma_upwellSO;
    else
        gamma_phi(i) = gamma_upwell_rest;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alpha_Cloud_obs_planetary = sum(Area.*alpha_Cloud_obs)/sum(Area); %0.2862; % Value from infinite series approx. on whole-Earth averages % (sum(Area.*alpha_Cloud_obs)/sum(Area));

%%Run model to equilibrium%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for model_type =3:3 


number_kappa_experiments = 1;
max_forcing = 1;


for kapper_iterations = 1:number_kappa_experiments

    

for forcing = 1:max_forcing
    if(forcing == 1)
        T_surface = linspace(298.15, 298.15, size_array) ; %273.15, 273.15, size_array);
        Northward_Heat_Transport = linspace(0.0,0.0, size_array-1);

        %%Reset clouds
        Cloud_Amount = Cloud_Amount_obs;
        Cloud_insolation_fraction = Cloud_insolation_fraction_obs;
        
        %c_epsilonCloudy = c_epsilonCloudy_obs;
        for i=1:size_array
            c_epsilonCloudy(i) = sum(Area.*c_epsilonCloudy_obs)/sum(Area);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
   
    model_type
    DeltaT_deepocean = 0.0;

    %%%%%%%%%%%%%%%
    tmax = 365*100*24; %initial spin up (number of 'days' of interation)

    %%%%%%%%%%%%%%%%%

    for t=1:365*100*24 %tmax %time loop, number of days

        

        if(forcing == 2 & model_type >= 1)
            for i=1:size_array
                c_epsilonCloudy(i) = sum(Area.*c_epsilonCloudy_obs)/sum(Area);
            end
        end
        
        if(forcing == 1)
            %alpha_cloud = alpha_Cloud_obs_planetary*(1.0 + (1-alpha_Cloud_obs_planetary)*beta_ClearSky*(0.5*(3*sin(phi_rad).*sin(phi_rad) - 1.0)));  %
            alpha_cloud = alpha_Cloud_obs;
        end
        alpha_Cloud_planetary = sum(Area.*alpha_cloud)/sum(Area);

        kappa_poleward_old = kappa_poleward;
        if(forcing == 1)
            kappa_poleward = kappa_standard;
        end
        
        

       
            
        for i=1:size_array-1
                
                    
             kappa_poleward(i) = kappa_standard(i) * (1 + function_ratio_Latent_Dry(T_surface(i), T_surface(i)+1.0, 0.70)) / (1 + function_ratio_Latent_Dry(Annual_T_obs(i), Annual_T_obs(i)+1.0, 0.70));
                    
             
             
               
        end
      

        

         

        

        

         

        

        

        

        


        %Transient deep ocean exchanges%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Heating_deep = 0.0;
        Heating_surface = linspace(0.0,0.0,size_array);
        
        DeltaT_deepocean = DeltaT_deepocean + Heating_deep/(c_p*Mass_ocean);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %Important!!!: Use the temperature at the unadjusted elevation to
        %calculate horizontal heat fluxes (since diffusivity calculated at
        %modern elevation)
        %calculate horizontal heat transport%%%%%%%%%%%%%%%%%%%%%%
        for i=1:size_array-1
            

            Northward_Heat_Transport(i) = -(kappa_poleward(i)*(T_surface(i+1)-T_surface(i))*Length_phi(i))/(pi()*R_Earth/size_array);

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        T_surface_old = T_surface;
        %Update temperatures %%%%%%%%%
        %All temperatures are at modern elevation %%%%%%%%%%%%%%%%%%
        T_surface(1) = T_surface(1) + dt*(1/c(1))*( Area(1)*(S_in(1) + RF(1) - L_out(1) - S_out(1) + Heating_surface(1)) - Northward_Heat_Transport(1));
        for i=2:size_array-1
            T_surface(i) = T_surface(i) + dt*(1/c(i))*(Area(i)*(S_in(i) + RF(i) - L_out(i) - S_out(i) + Heating_surface(i)) + Northward_Heat_Transport(i-1) - Northward_Heat_Transport(i));
        end
        T_surface(size_array) = T_surface(size_array) + dt*(1/c(size_array))*(Area(size_array)*(S_in(size_array) + RF(size_array) - L_out(size_array) - S_out(size_array) + Heating_surface(size_array)) + Northward_Heat_Transport(size_array-1));
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %Now calculate the pressure and temperature at the adjusted elevation
        Pressure_adjusted = Pressure_ERA5 + dp_dz * (Elevation_adjusted + Antarctic_ice_sheet_elevation - Elevation_GMTED2010); %The pressure at the new elevation
        T_adjusted = T_surface + dT_dz * (Elevation_adjusted + Antarctic_ice_sheet_elevation - Elevation_GMTED2010); %The temperature at the new elevation

        fraction_current_ice_sheet = 0.7;
        for(i5 = 1:23)

            if(i5 >= 1 & i5 <= 5)
                for j1=1:size_85_90S
                    T_adjusted_85_90S(j1) = T_surface(i5) + dT_dz * ((Elevation_adjusted(i5)/mean_elevation_85_90S_34Ma)*alt_85_90S(j1) + Antarctic_ice_sheet_elevation_85_90S(i5,j1) - Elevation_GMTED2010(i5));
                

                    if (T_adjusted_85_90S(j1) >= Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_85_90S(i5,j1) = 0.0;
                    end
                    if (T_adjusted_85_90S(j1) <= Antarctic_ice_sheet_minT(i5))
                        Antarctic_ice_sheet_elevation_85_90S(i5,j1) = Antarctic_ice_sheet_elevation_max_85_90S(i5,j1); %fraction_current_ice_sheet*Elevation_GMTED2010(1) ;%Can use i5 in place of 1 to set to maximum at that location %Antarctic_ice_sheet_elevation_max(i5);
                    end
                    if (T_adjusted_85_90S(j1) > Antarctic_ice_sheet_minT(i5) & T_adjusted_85_90S(j1) < Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_85_90S(i5,j1) = Antarctic_ice_sheet_elevation_max_85_90S(i5,j1) * abs(( Antarctic_ice_sheet_maxT - T_adjusted_85_90S(j1)  ) / (Antarctic_ice_sheet_maxT - Antarctic_ice_sheet_minT(i5)));
                    end
                    
                    BlockingAndFlow_coeff = 25.0; %in m the altitude over which ice sheet thickness halves as it flows downhill inbcluding when some areas are never sunlit due to high latitudes
                    %Blocking of sunlight at high latitude and downhill flow of ice sheets
                    if(j1 < size_85_90S)
                        if(Antarctic_ice_sheet_elevation_85_90S(i5,j1+1) > 10.0*0.001 & Antarctic_ice_sheet_elevation_85_90S(i5,j1) < Antarctic_ice_sheet_elevation_85_90S(i5,j1+1)*(1-exp(-(1000.0*(alt_85_90S(j1+1)-alt_85_90S(j1))*log(2.0)/(BlockingAndFlow_coeff)))) & T_adjusted_85_90S(j1) < 273.150) 
                            Antarctic_ice_sheet_elevation_85_90S(i5,j1) = Antarctic_ice_sheet_elevation_85_90S(i5,j1+1)*(1-exp(-(1000.0*(alt_85_90S(j1+1)-alt_85_90S(j1))*log(2.0)/(BlockingAndFlow_coeff)))); 
                        end
                    end
                end
                
                
                %Calculate average ice sheet elevation
                
                mean_ice_sheet = 0;
                for j1=1:size_85_90S
                    mean_ice_sheet = mean_ice_sheet + (cdf_alt_85_90S(j1+1) - cdf_alt_85_90S(j1))*Antarctic_ice_sheet_elevation_85_90S(i5,j1);
                end

                Antarctic_ice_sheet_elevation(i5) = mean_ice_sheet;

                %calculate average 
                mean_T = 0.0;
                mean_alpha_clearSky = 0.0;
                for j1 = 1:size_85_90S
                    mean_T = mean_T + (cdf_alt_85_90S(j1+1) - cdf_alt_85_90S(j1))*T_adjusted_85_90S(j1);

                    if(alt_85_90S(j1) > 0.001) %land
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_85_90S(j1+1) - cdf_alt_85_90S(j1))*function_mean_alpha_T_erf(T_adjusted_85_90S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 1.0 );
                    else %sea
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_85_90S(j1+1) - cdf_alt_85_90S(j1))*function_mean_alpha_T_erf(T_adjusted_85_90S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 0.0 );
                    end 
                end
                T_adjusted(i5) = mean_T;
                alpha_surface_mean_ClearSky(i5) = mean_alpha_clearSky;
                alpha_surface_ClearSky(i5) = (1.0 + (1.0-mean_alpha_clearSky)*beta_ClearSky * (0.5*( 3* sin(phi_rad(i5))*sin(phi_rad(i5)) - 1.0 ))) *mean_alpha_clearSky ; %Legendre polynomial
                
            end

            if(i5 >= 6 & i5 <= 10)

                for j1=1:size_80_85S
                    T_adjusted_80_85S(j1) = T_surface(i5) + dT_dz * ((Elevation_adjusted(i5)/mean_elevation_80_85S_34Ma)*alt_80_85S(j1) + Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) - Elevation_GMTED2010(i5));
                


                    if (T_adjusted_80_85S(j1) >= Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) = 0.0;
                    end
                    if (T_adjusted_80_85S(j1) <= Antarctic_ice_sheet_minT(i5))
                        Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) = Antarctic_ice_sheet_elevation_max_80_85S(i5-5,j1); %fraction_current_ice_sheet*Elevation_GMTED2010(1) ;%Can use i5 in place of 1 to set to maximum at that location %Antarctic_ice_sheet_elevation_max(i5);
                    end
                    if (T_adjusted_80_85S(j1) > Antarctic_ice_sheet_minT(i5) & T_adjusted_80_85S(j1) < Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) = Antarctic_ice_sheet_elevation_max_80_85S(i5-5,j1) * abs(( Antarctic_ice_sheet_maxT - T_adjusted_80_85S(j1)  ) / (Antarctic_ice_sheet_maxT - Antarctic_ice_sheet_minT(i5)));
                    end

                    BlockingAndFlow_coeff = 25.0; %in m the altitude over which ice sheet thickness halves as it flows downhill inbcluding when some areas are never sunlit due to high latitudes
                    %Blocking of sunlight at high latitude and downhill flow of ice sheets
                    if(j1 < size_80_85S)
                        if( Antarctic_ice_sheet_elevation_80_85S(i5-5,j1+1) > 10.0*0.001 & Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) < Antarctic_ice_sheet_elevation_80_85S(i5-5,j1+1)*(1-exp(-(1000.0*(alt_80_85S(j1+1)-alt_80_85S(j1))*log(2.0)/(BlockingAndFlow_coeff)))) & T_adjusted_80_85S(j1) < 273.15) 
                            Antarctic_ice_sheet_elevation_80_85S(i5-5,j1) = Antarctic_ice_sheet_elevation_80_85S(i5-5,j1+1)*(1-exp(-(1000.0*(alt_80_85S(j1+1)-alt_80_85S(j1))*log(2.0)/(BlockingAndFlow_coeff)))); 
                        end
                    end
                end
                
                
                %Calculate average ice sheet elevation
                
                mean_ice_sheet = 0;
                for j1=1:size_80_85S
                    mean_ice_sheet = mean_ice_sheet + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1))*Antarctic_ice_sheet_elevation_80_85S(i5-5,j1);
                end

                Antarctic_ice_sheet_elevation(i5) = mean_ice_sheet;
                
                %calculate average 
                mean_T = 0.0;
                mean_alpha_clearSky = 0.0;
                for j1 = 1:size_80_85S
                    mean_T = mean_T + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1))*T_adjusted_80_85S(j1);

                    if(alt_80_85S(j1) > 0.001) %land
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1))*function_mean_alpha_T_erf(T_adjusted_80_85S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 1.0 );
                    else %sea
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1))*function_mean_alpha_T_erf(T_adjusted_80_85S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 0.0 );
                    end 
                end
                T_adjusted(i5) = mean_T;
                alpha_surface_mean_ClearSky(i5) = mean_alpha_clearSky;
                alpha_surface_ClearSky(i5) = (1.0 + (1.0-mean_alpha_clearSky)*beta_ClearSky * (0.5*( 3* sin(phi_rad(i5))*sin(phi_rad(i5)) - 1.0 ))) *mean_alpha_clearSky ; %Legendre polynomial
                
            end

            if(i5 >= 11 & i5 <= 15)

                for j1=1:size_75_80S
                    T_adjusted_75_80S(j1) = T_surface(i5) + dT_dz * ((Elevation_adjusted(i5)/mean_elevation_75_80S_34Ma)*alt_75_80S(j1) + Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) - Elevation_GMTED2010(i5));
                


                    if (T_adjusted_75_80S(j1) >= Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) = 0.0;
                    end
                    if (T_adjusted_75_80S(j1) <= Antarctic_ice_sheet_minT(i5))
                        Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) = Antarctic_ice_sheet_elevation_max_75_80S(i5-10,j1); %fraction_current_ice_sheet*Elevation_GMTED2010(1) ;%Can use i5 in place of 1 to set to maximum at that location %Antarctic_ice_sheet_elevation_max(i5);
                    end
                    if (T_adjusted_75_80S(j1) > Antarctic_ice_sheet_minT(i5) & T_adjusted_75_80S(j1) < Antarctic_ice_sheet_maxT)
                        Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) = Antarctic_ice_sheet_elevation_max_75_80S(i5-10,j1) * abs(( Antarctic_ice_sheet_maxT - T_adjusted_75_80S(j1)  ) / (Antarctic_ice_sheet_maxT - Antarctic_ice_sheet_minT(i5)));
                    end

                    BlockingAndFlow_coeff = 25.0; %in m the altitude over which ice sheet thickness halves as it flows downhill inbcluding when some areas are never sunlit due to high latitudes
                    %Blocking of sunlight at high latitude and downhill flow of ice sheets
                    if(j1 < size_75_80S)
                        if (Antarctic_ice_sheet_elevation_75_80S(i5-10,j1+1) > 10.0*0.001 & Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) < Antarctic_ice_sheet_elevation_75_80S(i5-10,j1+1)*(1-exp(-(1000.0*(alt_75_80S(j1+1)-alt_75_80S(j1))*log(2.0)/(BlockingAndFlow_coeff)))) & T_adjusted_75_80S(j1) < 273.15) 
                            Antarctic_ice_sheet_elevation_75_80S(i5-10,j1) = Antarctic_ice_sheet_elevation_75_80S(i5-10,j1+1)*(1-exp(-(1000.0*(alt_75_80S(j1+1)-alt_75_80S(j1))*log(2.0)/(BlockingAndFlow_coeff)))); 
                        end
                    end
                end
                
                
                %Calculate average ice sheet elevation
                
                mean_ice_sheet = 0;
                for j1=1:size_75_80S
                    mean_ice_sheet = mean_ice_sheet + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1))*Antarctic_ice_sheet_elevation_75_80S(i5-10,j1);
                end

                Antarctic_ice_sheet_elevation(i5) = mean_ice_sheet;
                
                %calculate average 
                mean_T = 0.0;
                mean_alpha_clearSky = 0.0;
                for j1 = 1:size_75_80S
                    mean_T = mean_T + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1))*T_adjusted_75_80S(j1);

                    if(alt_75_80S(j1) > 0.001) %land
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1))*function_mean_alpha_T_erf(T_adjusted_75_80S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 1.0 );
                    else %sea
                        mean_alpha_clearSky = mean_alpha_clearSky + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1))*function_mean_alpha_T_erf(T_adjusted_75_80S(j1), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, 0.0 );
                    end 
                end
                T_adjusted(i5) = mean_T;
                alpha_surface_mean_ClearSky(i5) = mean_alpha_clearSky;
                alpha_surface_ClearSky(i5) = (1.0 + (1.0-mean_alpha_clearSky)*beta_ClearSky * (0.5*( 3* sin(phi_rad(i5))*sin(phi_rad(i5)) - 1.0 ))) *mean_alpha_clearSky ; %Legendre polynomial
                
            end


            if(i5 >= 16)

                if (T_adjusted(i5) >= Antarctic_ice_sheet_maxT)
                    Antarctic_ice_sheet_elevation(i5) = 0.0;
                end
                if (T_adjusted(i5) <= Antarctic_ice_sheet_minT(i5))
                    Antarctic_ice_sheet_elevation(i5) = Antarctic_ice_sheet_elevation_max(i5); %fraction_current_ice_sheet*Elevation_GMTED2010(1) ;%Can use i5 in place of 1 to set to maximum at that location %Antarctic_ice_sheet_elevation_max(i5);
                end
                if (T_adjusted(i5) > Antarctic_ice_sheet_minT(i5) & T_adjusted(i5) < Antarctic_ice_sheet_maxT)
                    Antarctic_ice_sheet_elevation(i5) = Antarctic_ice_sheet_elevation_max(i5) * abs(( Antarctic_ice_sheet_maxT - T_adjusted(i5)  ) / (Antarctic_ice_sheet_maxT - Antarctic_ice_sheet_minT(i5)));
                    %Antarctic_ice_sheet_elevation(i5) = fraction_current_ice_sheet*Elevation_GMTED2010(1) * abs(( Antarctic_ice_sheet_maxT - T_adjusted(i5)  ) / (Antarctic_ice_sheet_maxT - Antarctic_ice_sheet_minT(i5))); %This way initiation is identical for any elevation start
                end
            end

            
        end

        % Update albedo and emissivity %%%%%%%%%%%%%%%
    
        for i=1:size_array

            
            
            %alpha_surface(i) =function_surface_alpha_phi(phi_rad(i), function_mean_alpha_T(T_surface(i), T_cold,alpha_mean_cold, T_warm,alpha_mean_warm));

            %Note use elevation-adjusted temperature for the calculation
            if(i >= 16)
                alpha_surface_mean_ClearSky(i) = function_mean_alpha_T_erf(T_adjusted(i), alpha_cold_land, alpha_warm_land, T_cold_land, T_warm_land, alpha_warm_ocean, alpha_cold_ocean, T_cold_ocean, T_warm_ocean, land_frac(i) );

                alpha_surface_ClearSky(i) = (1.0 + (1.0-alpha_surface_mean_ClearSky(i))*beta_ClearSky * (0.5*( 3* sin(phi_rad(i))*sin(phi_rad(i)) - 1.0 ))) *alpha_surface_mean_ClearSky(i) ; %Legendre polynomial


            end
            
                
            
            
            %For full infinite series ...
            
            alpha(i) = alpha_surface_ClearSky(i)*(1.0-Cloud_insolation_fraction(i)) + Cloud_insolation_fraction(i)*(alpha_cloud(i) + alpha_surface_mean_ClearSky(i)*(1-alpha_cloud(i))*(1-alpha_Cloud_planetary))/((1-alpha_surface_mean_ClearSky(i)*alpha_Cloud_planetary)) ; % alpha_surface_ClearSky(i)*(1.0 - alpha_cloud(i))*(1.0 - alpha_Cloud_obs_planetary)/(1.0 - alpha_surface_ClearSky(i)*alpha_Cloud_obs_planetary) );
        
            
            
            

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        %%Calculate emissivity in relation to surface temperature%%%%%%%%%%
        %epsilon_Clear_Sky_calc = function_epsilon(T_surface, Coefficients_linear(1),Coefficients_linear(2)) ;
        
        for i=1:size_array
            epsilon_Clear_Sky_calc(i) = function_epsilon_multi(T_adjusted(i), Ztrop(i)-Elevation_adjusted(i), RH_ERA5(i), Pressure_adjusted(i), c0, c1, c2 ,c3, c4);
            epsilon_ClearSky_calc2(i) = function_epsilon_multi(Annual_T_obs(i), Ztrop(i)-Elevation_GMTED2010(i), RH_ERA5(i), Pressure_ERA5(i), c0, c1, c2 ,c3, c4);
            if(epsilon_Clear_Sky_calc(i) > 0.96)
                epsilon_Clear_Sky_calc(i) = 0.96;
            end
            if(epsilon_Clear_Sky_calc(i) < 0.1)
            epsilon_Clear_Sky_calc(i) = 0.1;
            end
            epsilon_Cloudy_calc(i) = 1.0 - c_epsilonCloudy(i)*(1-epsilon_Clear_Sky_calc(i));
            %Cloud impact
            epsilon(i) = (1-Cloud_Amount(i))*epsilon_Clear_Sky_calc(i) + Cloud_Amount(i)*epsilon_Cloudy_calc(i);
           

        end
    

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %Update vertical energy balance%%
    
        S_out =alpha.*S_in_start;
        L_out = sigma*epsilon.*(T_surface.^4);

    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %Radiative forcing
        a_CO2_above285 = 5.35;%
        S_in = S_in_obs;
        if (forcing == 1)
            CO2_logchange = log(1);
        end
        if (forcing == 2)
            
            
            if(model_type == 3)
                CO2_logchange = 0.0;%log(2.0);
            end
            
        end
        for i=1:size_array
            RF(i) = Radiative_forcing_uniform;
        end
        
        
        %Calculate northward heat transport per metre
        f_NHT = Northward_Heat_Transport./Length_phi;
        
        
        %calc df_NHT/dy
        dNHT_dA = linspace(0.0,0.0, size_array);
        dNHT_dA_obs = linspace(0.0,0.0, size_array);
        for i=2:size_array-1
            dNHT_dA(i) = (Northward_Heat_Transport(i)-Northward_Heat_Transport(i-1))/(2*pi()*R_Earth*cos(phi_rad(i))*R_Earth*(phi_rad(i)-phi_rad(i-1))); %
            df_NHT_dy(i) = (f_NHT(i)-f_NHT(i-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
            dNHT_dA_obs(i) = (Northward_heat_flux_obs((i))-Northward_heat_flux_obs(i-1))/(2*pi()*R_Earth*cos(phi_rad(i))*R_Earth*(phi_rad(i)-phi_rad(i-1))); %(f_NHT(i-1)-f_NHT(i))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
            df_NHT_dy_obs(i) = (f_NHT_obs(i)-f_NHT_obs(i-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        end
        dNHT_dA(1) = (Northward_Heat_Transport(1))/(2*pi()*R_Earth*cos(phi_rad(1))*R_Earth*(phi_rad(2)-phi_rad(1)));
        df_NHT_dy(1) = (f_NHT(1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        dNHT_dA(size_array) = (-Northward_Heat_Transport(size_array-1))/(2*pi()*R_Earth*cos(phi_rad(size_array))*R_Earth*(phi_rad(size_array)-phi_rad(size_array-1))); f_NHT(size_array-1)/(R_Earth*(phi_rad(2)-phi_rad(1)));
        df_NHT_dy(size_array) = (-f_NHT(size_array-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        
        dNHT_dA_obs(1) = (Northward_heat_flux_obs(1))/(2*pi()*R_Earth*cos(phi_rad(1))*R_Earth*(phi_rad(2)-phi_rad(1)));
        dNHT_dA_obs(size_array) = (-Northward_heat_flux_obs((size_array-1)))/(2*pi()*R_Earth*cos(phi_rad(size_array))*R_Earth*(phi_rad(size_array)-phi_rad(size_array-1))); f_NHT(size_array-1)/(R_Earth*(phi_rad(2)-phi_rad(1)));
        df_NHT_dy_obs(1) = (f_NHT_obs(1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        df_NHT_dy_obs(size_array) = (-f_NHT_obs(size_array-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        
    end %End of loop for timesteps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dkappa_dy(1) = kappa_poleward(i)/(R_Earth*(phi_rad(2)-phi_rad(1)));
    dT_dy(1) = (T_surface(2)-T_surface(1))/(R_Earth*(phi_rad(2)-phi_rad(1)));
    for i=2:size_array-1
        dkappa_dy(i) = (kappa_poleward(i) - kappa_poleward(i-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
        dT_dy(i) = (T_surface(i+1)-T_surface(i))/(R_Earth*(phi_rad(i+1)-phi_rad(i)));
    end
    dkappa_dy(size_array) = -kappa_poleward(size_array-1)/(R_Earth*(phi_rad(size_array)-phi_rad(size_array-1)));

    d2T_dy2(1) = (dT_dy(1))/(R_Earth*(phi_rad(i+1)-phi_rad(i)));
    for i=2:size_array-1
        d2T_dy2(i) = (dT_dy(i)-dT_dy(i-1))/(R_Earth*(phi_rad(i)-phi_rad(i-1)));
    end
    d2T_dy2(size_array)= -dT_dy(size_array-1)/(R_Earth*(phi_rad(size_array)-phi_rad(size_array-1)));

    if(forcing == 1)
        T_spinup = T_surface;
    end
    
    if(Radiative_forcing_uniform < 0.1 & Percentage_Antarctica_elevation < 30.5 & Percentage_Antarctica_elevation > 29.5)
        T_surface_initial = T_adjusted;
    end

    

    

    if(model_type == 3 & forcing == 1)
        T_surface3 = T_surface;
        L_out3 = L_out;
        S_out3 = S_out;
        Northward_Heat_Transport3 = Northward_Heat_Transport;
        alpha3 = alpha;
        epsilon3 = epsilon;
        f_NHT3 = f_NHT;
        dNHT_dA3 = dNHT_dA;
        df_NHT_dy3 = df_NHT_dy;
        kappa3 = kappa_poleward;
        Heating_surface3 = Heating_surface;
        dkappa_dy3 = dkappa_dy;
        dT_dy3 = dT_dy;
        d2T_dy2_3 = d2T_dy2;
    end

    

    

    

    

    

    





if(model_type == 3 & forcing == 2)
    T_surface10 = T_surface;
    L_out10 = L_out;
    S_out10 = S_out;
    Northward_Heat_Transport10 = Northward_Heat_Transport;
    alpha10 = alpha;
    epsilon10 = epsilon;
    f_NHT10 = f_NHT;
    dNHT_dA10 = dNHT_dA;
    df_NHT_dy10 = df_NHT_dy;
    kappa10 = kappa_poleward;
    Heating_surface10 = Heating_surface;
    dkappa_dy10 = dkappa_dy;
    dT_dy10 = dT_dy;
    d2T_dy2_10 = d2T_dy2;
end





if (model_type == 3 & forcing >=1)
    Antarctic_Temperature84 = T_adjusted(6)
    Antarctic_Temperature83 = T_adjusted(7)
    Antarctic_Temperature82 = T_adjusted(8)
    Antarctic_Temperature81 = T_adjusted(9)
    Antarctic_Temperature80 = T_adjusted(10)
    Antarctic_Temperature79 = T_adjusted(11)
    Antarctic_Temperature78 = T_adjusted(12)
    Antarctic_Temperature77 = T_adjusted(13)
    Antarctic_Temperature76 = T_adjusted(14)
    Antarctic_Temperature75 = T_adjusted(15)

    Global_mean_warming = sum(Area.*T_adjusted)/sum(Area) - sum(Area.*Annual_T_obs)/sum(Area)
    
    Global_mean_T = sum(Area.*T_adjusted)/sum(Area)

  
    Antarctic_elevation = Elevation_adjusted(8)
    Antarctic_elevation80 = Elevation_adjusted(11);
    

    Antarctic_ice_sheet84 = Antarctic_ice_sheet_elevation(6);
    Antarctic_ice_sheet83 = Antarctic_ice_sheet_elevation(7);
    Antarctic_ice_sheet82 = Antarctic_ice_sheet_elevation(8);
    Antarctic_ice_sheet81 = Antarctic_ice_sheet_elevation(9);
    Antarctic_ice_sheet80 = Antarctic_ice_sheet_elevation(10);
    Antarctic_ice_sheet79 = Antarctic_ice_sheet_elevation(11);
    Antarctic_ice_sheet78 = Antarctic_ice_sheet_elevation(12);
    Antarctic_ice_sheet77 = Antarctic_ice_sheet_elevation(13);
    Antarctic_ice_sheet76 = Antarctic_ice_sheet_elevation(14);
    Antarctic_ice_sheet75 = Antarctic_ice_sheet_elevation(15);
    
    Altitude84 = NaN ;
    Altitude83 = NaN ;
    Altitude82 = NaN ;
    Altitude81 = NaN ;
    Altitude80 = NaN ;
    Altitude79 = NaN ;
    Altitude78 = NaN ;
    Altitude77 = NaN ;%alt_80_85S(size_80_85S);
    Altitude76 = NaN ;
    Altitude75 = NaN ;
    
    PercentageArea84 = 0;
    for j1=1:size_80_85S
        if(Antarctic_ice_sheet_elevation_80_85S(1,j1) > 0.001*0.1)
            PercentageArea84 = PercentageArea84 + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1));
        end
    end
    PercentageArea83 = 0;
    for j1=1:size_80_85S
        if(Antarctic_ice_sheet_elevation_80_85S(2,j1) > 0.001*0.1)
            PercentageArea83 = PercentageArea83 + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1));
        end
    end
    PercentageArea82 = 0;
    for j1=1:size_80_85S
        if(Antarctic_ice_sheet_elevation_80_85S(3,j1) > 0.001*0.1)
            PercentageArea82 = PercentageArea82 + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1));
        end
    end
    PercentageArea81 = 0;
    for j1=1:size_80_85S
        if(Antarctic_ice_sheet_elevation_80_85S(4,j1) > 0.001*0.1)
            PercentageArea81 = PercentageArea81 + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1));
        end
    end
    PercentageArea80 = 0;
    for j1=1:size_80_85S
        if(Antarctic_ice_sheet_elevation_80_85S(5,j1) > 0.001*0.1)
            PercentageArea80 = PercentageArea80 + (cdf_alt_80_85S(j1+1) - cdf_alt_80_85S(j1));
        end
    end
    PercentageArea79 = 0;
    for j1=1:size_75_80S
        if(Antarctic_ice_sheet_elevation_75_80S(1,j1) > 0.001*0.1)
            PercentageArea79 = PercentageArea79 + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1));
        end
    end
    PercentageArea78 = 0;
    for j1=1:size_75_80S
        if(Antarctic_ice_sheet_elevation_75_80S(2,j1) > 0.001*0.1)
            PercentageArea78 = PercentageArea78 + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1));
        end
    end
    PercentageArea77 = 0;
    for j1=1:size_75_80S
        if(Antarctic_ice_sheet_elevation_75_80S(3,j1) > 0.001*0.1)
            PercentageArea77 = PercentageArea77 + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1));
        end
    end
    PercentageArea76 = 0;
    for j1=1:size_75_80S
        if(Antarctic_ice_sheet_elevation_75_80S(2,j1) > 0.001*0.1)
            PercentageArea76 = PercentageArea76 + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1));
        end
    end
    PercentageArea75 = 0;
    for j1=1:size_75_80S
        if(Antarctic_ice_sheet_elevation_75_80S(5,j1) > 0.001*0.1)
            PercentageArea75 = PercentageArea75 + (cdf_alt_75_80S(j1+1) - cdf_alt_75_80S(j1));
        end
    end
    

    for j1=size_80_85S:-1:1
        if(Antarctic_ice_sheet_elevation_80_85S(1,j1) > 0.001*0.1 )
            Altitude84 = alt_80_85S(j1);
        end
        if(Antarctic_ice_sheet_elevation_80_85S(2,j1) > 0.001*0.1 )
            Altitude83 = alt_80_85S(j1);
        end
        if(Antarctic_ice_sheet_elevation_80_85S(3,j1) > 0.001*0.1 )
            Altitude82 = alt_80_85S(j1);
        end
        if(Antarctic_ice_sheet_elevation_80_85S(4,j1) > 0.001*0.1 )
            Altitude81 = alt_80_85S(j1);
        end
        if(Antarctic_ice_sheet_elevation_80_85S(5,j1) > 0.001*0.1 )
            Altitude80 = alt_80_85S(j1);
        end
    end
    for j1=size_75_80S:-1:1
        if(Antarctic_ice_sheet_elevation_75_80S(1,j1) > 0.001*0.1 )
            Altitude79 = alt_75_80S(j1);
        end
        if(Antarctic_ice_sheet_elevation_75_80S(2,j1) > 0.001*0.1 )
            Altitude78 = alt_75_80S(j1);
        end
        if(Antarctic_ice_sheet_elevation_75_80S(3,j1) > 0.001*0.1 )
            Altitude77 = alt_75_80S(j1);
        end
        if(Antarctic_ice_sheet_elevation_75_80S(4,j1) > 0.001*0.1 )
            Altitude76 = alt_75_80S(j1);
        end
        if(Antarctic_ice_sheet_elevation_75_80S(5,j1) > 0.001*0.1 )
            Altitude75 = alt_75_80S(j1);
        end
    end


   

    

    Alt_ice84 = 1000*((Elevation_adjusted(6) + Antarctic_ice_sheet_elevation(6) ) + (Antarctic_ice_sheet_maxT - T_adjusted(6))/dT_dz);
    Alt_ice83 = 1000*((Elevation_adjusted(7) + Antarctic_ice_sheet_elevation(7) ) + (Antarctic_ice_sheet_maxT - T_adjusted(7))/dT_dz);
    Alt_ice82 = 1000*((Elevation_adjusted(8) + Antarctic_ice_sheet_elevation(8) ) + (Antarctic_ice_sheet_maxT - T_adjusted(8))/dT_dz);
    Alt_ice81 = 1000*((Elevation_adjusted(9) + Antarctic_ice_sheet_elevation(9) ) + (Antarctic_ice_sheet_maxT - T_adjusted(9))/dT_dz);
    Alt_ice80 = 1000*((Elevation_adjusted(10) + Antarctic_ice_sheet_elevation(10) ) + (Antarctic_ice_sheet_maxT - T_adjusted(10))/dT_dz);
    Alt_ice79 = 1000*((Elevation_adjusted(11) + Antarctic_ice_sheet_elevation(11) ) + (Antarctic_ice_sheet_maxT - T_adjusted(11))/dT_dz);
    Alt_ice78 = 1000*((Elevation_adjusted(12) + Antarctic_ice_sheet_elevation(12) ) + (Antarctic_ice_sheet_maxT - T_adjusted(12))/dT_dz);
    Alt_ice77 = 1000*((Elevation_adjusted(13) + Antarctic_ice_sheet_elevation(13) ) + (Antarctic_ice_sheet_maxT - T_adjusted(13))/dT_dz);
    Alt_ice76 = 1000*((Elevation_adjusted(14) + Antarctic_ice_sheet_elevation(14) ) + (Antarctic_ice_sheet_maxT - T_adjusted(14))/dT_dz);
    Alt_ice75 = 1000*((Elevation_adjusted(15) + Antarctic_ice_sheet_elevation(15) ) + (Antarctic_ice_sheet_maxT - T_adjusted(15))/dT_dz);
    
    Results_table_Antarctica.SO_Temp(Table_row_Antarctica) = sum(Area(26:33).*T_adjusted(26:33))/sum(Area(26:33));
    Results_table_Antarctica.Low_Lat_Temp(Table_row_Antarctica) = sum(Area(61:120).*T_adjusted(61:120))/sum(Area(61:120));
    Results_table_Antarctica.PercentageElevation(Table_row_Antarctica) = Percentage_Antarctica_elevation;
    Results_table_Antarctica.RadiativeForcing(Table_row_Antarctica) = Radiative_forcing_uniform;

    Results_table_Antarctica.AntarcticTemperature84(Table_row_Antarctica) = Antarctic_Temperature84;
    Results_table_Antarctica.AntarcticTemperature83(Table_row_Antarctica) = Antarctic_Temperature83;
    Results_table_Antarctica.AntarcticTemperature82(Table_row_Antarctica) = Antarctic_Temperature82;
    Results_table_Antarctica.AntarcticTemperature81(Table_row_Antarctica) = Antarctic_Temperature81;
    Results_table_Antarctica.AntarcticTemperature80(Table_row_Antarctica) = Antarctic_Temperature80;
    Results_table_Antarctica.AntarcticTemperature79(Table_row_Antarctica) = Antarctic_Temperature79;
    Results_table_Antarctica.AntarcticTemperature78(Table_row_Antarctica) = Antarctic_Temperature78;
    Results_table_Antarctica.AntarcticTemperature77(Table_row_Antarctica) = Antarctic_Temperature77;
    Results_table_Antarctica.AntarcticTemperature76(Table_row_Antarctica) = Antarctic_Temperature76;
    Results_table_Antarctica.AntarcticTemperature75(Table_row_Antarctica) = Antarctic_Temperature75;

    Results_table_Antarctica.GlobalMeanWarming(Table_row_Antarctica) = Global_mean_warming;
    Results_table_Antarctica.GlobalMeanT(Table_row_Antarctica) = Global_mean_T - 273.15; %convert to °C
    Results_table_Antarctica.AntarcticElevation(Table_row_Antarctica) = Antarctic_elevation;

    Results_table_Antarctica.IceSheetThickness84(Table_row_Antarctica) = Antarctic_ice_sheet84;
    Results_table_Antarctica.IceSheetThickness83(Table_row_Antarctica) = Antarctic_ice_sheet83;
    Results_table_Antarctica.IceSheetThickness82(Table_row_Antarctica) = Antarctic_ice_sheet82;
    Results_table_Antarctica.IceSheetThickness81(Table_row_Antarctica) = Antarctic_ice_sheet81;
    Results_table_Antarctica.IceSheetThickness80(Table_row_Antarctica) = Antarctic_ice_sheet80;
    Results_table_Antarctica.IceSheetThickness79(Table_row_Antarctica) = Antarctic_ice_sheet79;
    Results_table_Antarctica.IceSheetThickness78(Table_row_Antarctica) = Antarctic_ice_sheet78;
    Results_table_Antarctica.IceSheetThickness77(Table_row_Antarctica) = Antarctic_ice_sheet77;
    Results_table_Antarctica.IceSheetThickness76(Table_row_Antarctica) = Antarctic_ice_sheet76;
    Results_table_Antarctica.IceSheetThickness75(Table_row_Antarctica) = Antarctic_ice_sheet75;
   
    Results_table_Antarctica.Percentage_Area_IceSheet_84(Table_row_Antarctica) = 100*PercentageArea84;
    Results_table_Antarctica.Percentage_Area_IceSheet_83(Table_row_Antarctica) = 100*PercentageArea83;
    Results_table_Antarctica.Percentage_Area_IceSheet_82(Table_row_Antarctica) = 100*PercentageArea82;
    Results_table_Antarctica.Percentage_Area_IceSheet_81(Table_row_Antarctica) = 100*PercentageArea81;
    Results_table_Antarctica.Percentage_Area_IceSheet_80(Table_row_Antarctica) = 100*PercentageArea80;
    Results_table_Antarctica.Percentage_Area_IceSheet_79(Table_row_Antarctica) = 100*PercentageArea79;
    Results_table_Antarctica.Percentage_Area_IceSheet_78(Table_row_Antarctica) = 100*PercentageArea78;
    Results_table_Antarctica.Percentage_Area_IceSheet_77(Table_row_Antarctica) = 100*PercentageArea77;
    Results_table_Antarctica.Percentage_Area_IceSheet_76(Table_row_Antarctica) = 100*PercentageArea76;
    Results_table_Antarctica.Percentage_Area_IceSheet_75(Table_row_Antarctica) = 100*PercentageArea75;
    
    Results_table_Antarctica.IceSheetAltitude84(Table_row_Antarctica) = 1000.0*Altitude84*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude83(Table_row_Antarctica) = 1000.0*Altitude83*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude82(Table_row_Antarctica) = 1000.0*Altitude82*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude81(Table_row_Antarctica) = 1000.0*Altitude81*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude80(Table_row_Antarctica) = 1000.0*Altitude80*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude79(Table_row_Antarctica) = 1000.0*Altitude79*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude78(Table_row_Antarctica) = 1000.0*Altitude78*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude77(Table_row_Antarctica) = 1000.0*Altitude77*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude76(Table_row_Antarctica) = 1000.0*Altitude76*Percentage_Antarctica_elevation/100.0;
    Results_table_Antarctica.IceSheetAltitude75(Table_row_Antarctica) = 1000.0*Altitude75*Percentage_Antarctica_elevation/100.0;

    Results_table_Antarctica.Altitude_for_ice84(Table_row_Antarctica) = Alt_ice84;
    Results_table_Antarctica.Altitude_for_ice83(Table_row_Antarctica) = Alt_ice83;
    Results_table_Antarctica.Altitude_for_ice82(Table_row_Antarctica) = Alt_ice82;
    Results_table_Antarctica.Altitude_for_ice81(Table_row_Antarctica) = Alt_ice81;
    Results_table_Antarctica.Altitude_for_ice80(Table_row_Antarctica) = Alt_ice80;
    Results_table_Antarctica.Altitude_for_ice79(Table_row_Antarctica) = Alt_ice79;
    Results_table_Antarctica.Altitude_for_ice78(Table_row_Antarctica) = Alt_ice78;
    Results_table_Antarctica.Altitude_for_ice77(Table_row_Antarctica) = Alt_ice77;
    Results_table_Antarctica.Altitude_for_ice76(Table_row_Antarctica) = Alt_ice76;
    Results_table_Antarctica.Altitude_for_ice75(Table_row_Antarctica) = Alt_ice75;
    
    
    Results_table_Antarctica.Antarctic_geoHeight(Table_row_Antarctica) = Antarctic_ice_sheet82+Antarctic_elevation;
    Results_table_Antarctica.Antarctic_geoHeight80(Table_row_Antarctica) = Antarctic_ice_sheet80+Antarctic_elevation80;
    
    Results_table_Antarctica.Northern_Temp(Table_row_Antarctica) = sum(Area(148:155).*T_adjusted(148:155))/sum(Area(148:155));

    Results_table_Antarctica.LTG(Table_row_Antarctica) = sum(Area(61:120).*T_adjusted(61:120))./sum(Area(61:120))-sum(Area(26:33).*T_adjusted(26:33))./sum(Area(26:33))


    T_surface_initial = T_surface
end

end

end

end 

    end 
end

writetable(Results_table_Antarctica, 'Results_table_Antarctica.csv')





%functions

function f_ratio_Latent_Dry = function_ratio_Latent_Dry(T1, T2, RH)
    L_v = 2.5e6; %J/kg latent heat water vapour
    R_v = 461; %Gas constant for water vapour
    c_p_dryair = 1000.5; %specific heat capacity dry air at constant pressure in J/(kgK)
    qstar1 = (30/50)*6.11*exp(L_v/R_v*((1/273.0)- (1/T1)));
    qstar2 = (30/50)*6.11*exp(L_v/R_v*((1/273.0)- (1/T2)));
    Latent = RH*L_v*(qstar2-qstar1)/1000;
    Dry = c_p_dryair*(T2 - T1);
    f_ratio_Latent_Dry = Latent/Dry;
end

function f_epsilonClearSky = function_epsilon(T, A, B)
    f_epsilonClearSky = A*T + B;
end


function mean_alpha = function_mean_alpha_T_erf(T_S, alpha_land_cold, alpha_land_warm, T_cold_land, T_warm_land, alpha_ocean_warm, alpha_ocean_cold, T_cold_ocean, T_warm_ocean, f_land)

    alpha_mean_Land_erf = (alpha_land_warm + alpha_land_cold)/2.0 - ((alpha_land_cold - alpha_land_warm)/2.0)*erf( (T_S - (T_cold_land + T_warm_land)/2.0)/((T_warm_land - T_cold_land)/2.0)) ;

    alpha_mean_Ocean_erf = (alpha_ocean_warm + alpha_ocean_cold)/2.0 - ((alpha_ocean_cold - alpha_ocean_warm)/2.0)*erf( (T_S - (T_cold_ocean + T_warm_ocean)/2.0)/((T_warm_ocean - T_cold_ocean)/2.0)) ;

    mean_alpha = f_land*alpha_mean_Land_erf + (1-f_land)*alpha_mean_Ocean_erf;
end

function epsilon = function_epsilon_multi(T, Delta_z, RH, pressure_surface, c0, c1, c2 ,c3, c4)

    epsilon = c0 + c1*T + c2*RH + c3 * pressure_surface + c4*Delta_z ;
end

function mean_alpha = function_mean_alpha_T(Temp, a,b,c,d)
    %define turning points (a,b) and (c,d)
    
    
    k = -6.0*(b-d)/((a-c)*(a-c)*(a-c));
    h = ((b+d)/2.0) - (( (b-d)*(a+c)*(a*a + c*c - 4.0*a*c) ) / (2.0*(a-c)*(a-c)*(a-c)) );
    mean_alpha = d;
    
    if(Temp > c)
        mean_alpha = d;
    end
    if(Temp > a & Temp <= c)
        mean_alpha = k*((Temp*Temp*Temp)/3.0 - (a+c)*Temp*Temp/2 + a*c*Temp) + h;
    end
    if(Temp <= a)
        mean_alpha = b;
    end

end



function surface_alpha = function_surface_alpha_phi(phi,  mean_alpha)

    surface_alpha = mean_alpha*(1.0 + (1.0-mean_alpha)*(0.5*(3.0*sin (phi) * sin (phi) - 1.0)));

end






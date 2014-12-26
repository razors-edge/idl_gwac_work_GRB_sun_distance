pro Hour_angle_elevation_SWIFTGRB_sun_Santiago_test
close,/all
inputfile=filepath('test.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={$
ID:'',trig_UT:0.0d,trig_num:0L,radeg:0.0d,decdeg:0.0d,$
trig_yy:0,trig_mm:0,trig_dd:0,$
duration:0.0d,radeg_sun:0.0d,decdeg_sun:0.0d,distance_d:0.0d$
,zenith_solar_present:0.0d,altitude:0.0d, azimuth:0.0d}
data=replicate(record,maxrec)
str=''

openr,50,inputfile
point_lun,50,0
m=0
for i=0L, maxrec-1 do begin
readf,50,str

word = strsplit(str,/EXTRACT)
data[i].ID = word[0]
data[i].trig_UT=ten(word[1])
data[i].trig_num = word[2]
data[i].radeg = word[3]
data[i].decdeg = word[4]
data[i].duration = word[5]
data[i].trig_yy = '20'+STRMID(data[i].ID,0,2) 
data[i].trig_mm = STRMID(data[i].ID,2,2) 
data[i].trig_dd = STRMID(data[i].ID,4,2)

jdcnv, data[i].trig_yy,data[i].trig_mm,data[i].trig_dd,data[i].trig_UT, jd
sunpos, jd,radeg_sun,decdeg_sun

newyear=JULDAY(1,1,data[i].trig_yy,0,0,0)
utc = jd-newyear

;utc = data[i].trig_UT 
long = ten(0,0,0)
deta_local = ten(0,0,0)
local_sidereal_time,long,jd,lst
;alpha_local_time = lst
lat = float(deta_local)
print,lst,lat,long,utc
data[i].zenith_solar_present = zenith(utc,lat,long)*180/3.1415926
ha=(lst - data[i].radeg)
hadec2altaz, ha, data[i].decdeg, lat, alt, az
data[i].altitude = alt
data[i].azimuth = az

data[i].radeg_sun = radeg_sun
data[i].decdeg_sun = decdeg_sun
;angular_distance,data[i].radeg,data[i].decdeg,data[i].radeg_sun,data[i].decdeg_sun,data[i].distance_d
angular_distance,data[i].radeg,data[i].decdeg,data[i].radeg_sun,data[i].decdeg_sun,distance_d
data[i].distance_d = distance_d
;if data[i].zenith_solar_present gt 110 and data[i].altitude gt 30 then begin
;if data[i].zenith_solar_present gt 110 then begin
m=m+1
print,m,"  GRB"+data[i].ID,adstring(data[i].radeg,data[i].decdeg,2), data[i].radeg,data[i].decdeg,$
"  sun ",adstring(data[i].radeg_sun,data[i].decdeg_sun,2),data[i].radeg_sun,data[i].decdeg_sun,$
"  distance:",data[i].distance_d,"  solar zenith:",data[i].zenith_solar_present,$
"  grb altitude:",data[i].altitude,"  grb azimuth:",data[i].azimuth
endfor

close,50
close,/all
print,'Done'
end
pro Hour_angle_elevation_FERMIGRB_sun_xinglong
close,/all
inputfile=filepath('fermigrb_table_1364439272.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile=filepath('HA_ELEV_fermigrb_table_1364439272.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile1=filepath('HA_ELEV_fermigrb_table_1364439272',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile2=filepath('HA_ELEV_fermigrb_table_1364359868_freq',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
openw,80,outputfile,width=2000


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={ID:'',grbname:' ',radeg:0.0d,decdeg:0.0d,trig_yy:0,trig_mm:0,trig_dd:0,trig_UT:0.0d,reliability:0.0D,$
radeg_sun:0.0d,decdeg_sun:0.0d,distance_d:0.0d,zenith_solar_present:0.0d,altitude:0.0d, azimuth:0.0d}
data=replicate(record,maxrec)
str=''

entry_device=!d.name
!p.multi=[0,1,2]
set_plot,'ps'
device,file=outputfile1 + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0


openr,50,inputfile
point_lun,50,0
m=0
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,/EXTRACT)
data[i].ID = word[0]
data[i].grbname = word[1]
data[i].radeg = word[2]
data[i].decdeg = word[3]
data[i].trig_yy = word[4]
data[i].trig_mm = word[5]
data[i].trig_dd = word[6]
data[i].trig_UT = word[7]
data[i].reliability = word[8]

jdcnv, data[i].trig_yy,data[i].trig_mm,data[i].trig_dd,data[i].trig_UT, jd
sunpos, jd,radeg_sun,decdeg_sun

newyear=JULDAY(1,1,data[i].trig_yy,0,0,0)
utc = jd-newyear

;utc = data[i].trig_UT 
long = ten(117,34,28.35)
deta_local = ten(40,23,45.36)
local_sidereal_time,long,jd,lst
;alpha_local_time = lst
lat = float(deta_local)
;print,alpha_local_time,lat,long
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
print,m,' ',data[i].grbname,adstring(data[i].radeg,data[i].decdeg,2),"  sun ",adstring(data[i].radeg_sun,data[i].decdeg_sun,2),$
"  distance:",data[i].distance_d,"  solar zenith:",data[i].zenith_solar_present,$
"  grb altitude:",data[i].altitude,"  grb azimuth:",data[i].azimuth
printf,80,m,' ',data[i].grbname,adstring(data[i].radeg,data[i].decdeg,2),"  sun ",adstring(data[i].radeg_sun,data[i].decdeg_sun,2),$
"  distance:",data[i].distance_d,"  solar zenith:",data[i].zenith_solar_present,$
"  grb altitude:",data[i].altitude,"  grb azimuth:",data[i].azimuth
;endif
endfor

bin=( FindGen(19) * 10 ) - 90
n=make_array(19, /INTEGER )
n1=make_array(19, /INTEGER )
for j=0L, 17 do begin
n[j]=0L
n1[j]=0L
index=WHERE(((data.altitude gt bin[j]) and (data.altitude le bin[j+1])), count )
n[j] = count
index1=WHERE(((data.altitude gt bin[j]) and (data.altitude le bin[j+1])$
 and (data.zenith_solar_present gt 110)), count1 )
n1[j] = count1
endfor

;print,n

cthick=2
csize=1
plot,bin,n,$
xrange=[-100,100],yrange=[0,130],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='Anltitude of Fermi GRBs at Xinglong (degree)',$
XCHARSIZE=1.5,$
ytitle='Number',YCHARSIZE=1.5, $
psym=8,charthick=3,$
color=0,position=[0.15,0.15,0.9,0.9],/nodata
FOR z = 0, 18 DO begin
if z ge 12 then begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n[z],2
xyouts,bin[z]-15,n[z]+10,n[z],charsize=csize,color=2,charthick=cthick
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n1[z],1
xyouts,bin[z]-15,n[z]+5,n1[z],charsize=csize,color=1,charthick=cthick
endif else begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n[z],0
xyouts,bin[z]-15,n[z]+10,n[z],charsize=csize,color=0,charthick=cthick
endelse
endfor

oplot,[30,30],[0,140],$
linestyle=1,thick=8,color=3

xyouts,-70,125,'All GRBs',charsize=csize,color=0,charthick=cthick
xyouts,-70,120,'Anltitude of GRBs > 30 deg.',charsize=csize,color=2,charthick=cthick
xyouts,-70,115,'Solar zenith at trigger time > 110 deg.',charsize=csize,color=1,charthick=cthick



device,/close_file

entry_device=!d.name
!p.multi=[0,1,2]
set_plot,'ps'
device,file=outputfile2 + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

bin=( FindGen(19) * 10 ) - 90
n=make_array(19 )
n1=make_array(19 )
n2=make_array(19 )
sum = 0.
sum1 = 0.
sum2 = 0.
for j=0L, 17 do begin
n[j]=0L
n1[j]=0L
index=WHERE(((data.altitude gt bin[j]) and (data.altitude le bin[j+1])), count )
sum = sum + count
n[j] = sum
index1=WHERE(((data.altitude gt bin[j]) and (data.altitude le bin[j+1])$
 and (data.zenith_solar_present gt 110)), count1 )
sum1 = sum1 + count1
n1[j] = sum1
index2=WHERE(((data.altitude gt bin[j]) and (data.altitude le bin[j+1])$
 and (data.zenith_solar_present gt 110) and (data.altitude ge 30)), count2 )
sum2 = sum2 + count2
n2[j] = sum2
endfor

print,n,n1,n2

cthick=2
csize=1
plot,bin,n,$
xrange=[-100,100],yrange=[0,1.2],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='Altitude of Swift GRBs at Xinglong (degree)',$
XCHARSIZE=1.5,$
ytitle='Cumulative Frequency',YCHARSIZE=1.5, $
psym=8,charthick=3,$
color=0,position=[0.15,0.15,0.9,0.9],/nodata
FOR z = 0, 17 DO begin
if z ge 12 then begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n[z]/n[17],2
xyouts,bin[z]-1,n[z]/n[17]+0.1,STRMID(STRTRIM(string(n[z]/n[17]),1),0,4),charsize=csize,color=2,charthick=cthick
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n2[z]/n[17],1
xyouts,bin[z]-1,n[z]/n[17]+0.05,STRMID(STRTRIM(string(n2[z]/n[17]),1),0,4),charsize=csize,color=1,charthick=cthick
endif else begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+5,$ 
n[z]/n[17],0
xyouts,bin[z]-1,n[z]/n[17]+0.1,STRMID(STRTRIM(string(n[z]/n[17]),1),0,4),charsize=csize,color=0,charthick=cthick
endelse
print,n[z],n1[z],n[17],n[z]/n[17],n1[z]/n[17],n2[z]/n[17]
endfor

oplot,[30,30],[0,100],$
linestyle=1,thick=8,color=3

xyouts,-70,1.15,'All GRBs',charsize=csize,color=0,charthick=cthick
xyouts,-70,1.10,'Anltitude of GRBs > 30 deg.',charsize=csize,color=2,charthick=cthick
xyouts,-70,1.05,'Solar zenith at trigger time > 110 deg.',charsize=csize,color=1,charthick=cthick






close,50
close,80
close,/all
device,/close_file
print,'Done'
end
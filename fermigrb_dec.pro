pro FERMIGRB_DEC
close,/all
inputfile=filepath('fermigrb_table_1364439272.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile1=filepath('fermigrb_dec',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={ID:'',grbname:' ',radeg:0.0d,decdeg:0.0d,trig_yy:0,trig_mm:0,trig_dd:0,trig_UT:0.0d,reliability:0.0D,$
radeg_sun:0.0d,decdeg_sun:0.0d,distance_d:0.0d}
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
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,/EXTRACT)
data[i].ID = word[0]
data[i].grbname = word[1]
data[i].radeg = word[2]
data[i].decdeg=word[3]
data[i].trig_yy = word[4]
data[i].trig_mm = word[5]
data[i].trig_dd = word[6]
data[i].trig_UT = word[7]
data[i].reliability = word[8]

endfor

bin=( FindGen(19) * 10 ) - 90
n=make_array(19)
for j=0L, 17 do begin
n[j]=0.
index=WHERE(((data.decdeg gt bin[j]) and (data.decdeg le bin[j+1])), count )
n[j] = count
endfor

;print,n

cthick=2
csize=1
plot,bin,n,$
xrange=[-100,100],yrange=[0,12],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='DEC of FERMI GRBs (degree)',$
XCHARSIZE=1.5,$
ytitle='Percent %',YCHARSIZE=1.5, $
psym=8,charthick=3,$
color=0,position=[0.15,0.15,0.9,0.9],/nodata
FOR z = 0, 18 DO begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+8,$ 
(n[z]/maxrec)*100.0,1
xyouts,bin[z]-1,(n[z]/maxrec)*100.0+2,STRMID(STRTRIM(string(n[z]/maxrec*100.0),1),0,4),charsize=csize,color=0,charthick=cthick
endfor


close,50
close,/all
device,/close_file
print,'Done'
end
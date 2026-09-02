import re

with open("lib/presentation/pages/akademik/akademik_tab.dart", "r") as f:
    text = f.read()

start_idx = text.find("  Widget _buildJadwalTab(List<dynamic> jadwalList) {")
end_idx = text.find("  Widget _buildHasilStudiTab(dynamic userData) {")

if start_idx == -1 or end_idx == -1:
    print("Not found")
    exit(1)

new_meth = """  Widget _buildJadwalTab(List<dynamic> jadwalList) {
    if (jadwalList.isEmpty) {
      return _buildEmptyState(
        'Tidak ada jadwal aktif\\nGagal merender atau kosong',
        Icons.event_busy_rounded,
      );
    }

    final Map<String, List<dynamic>> groupedJadwal = {
      'Senin': [],
      'Selasa': [],
      'Rabu': [],
      'Kamis': [],
      'Jumat': [],
      'Sabtu': [],
      'Minggu': [],
      'Lainnya': [],
    };

    for (var j in jadwalList) {
      final String waktu = (j.ruangWaktu ?? '').toLowerCase();
      if (waktu.startsWith('sen')) {
        groupedJadwal['Senin']!.add(j);
      } else if (waktu.startsWith('simport re

with open("libdw
with opsa'    text = f.read()

start_idx = text.find("  Widget _buildJadwalTab(Lisdw
start_idx = text.;
 end_idx = text.find("  Widget _buildHasilStudiTab(dynamic userData) {")

if dd
if start_idx == -1 or end_idx == -1:
    print("Not found")
    exit(['J    print("Not found")
    exit(1)
kt    exit(1)

new_meth{

new_meth oup    if (jadwalList.isEmpty) {
      return _buildEmptyState(
    ')      return _buildEmptyStatin        'Tidak ada jadwal akt
         Icons.event_busy_rounded,
      );
    }

    final Min      );
    }

    final Map<Stys    }

(k
    gr      'Senin': [],
      'Selasa': [],
      'Rabu': ff      'Selasa': [ou      'Rabu': [],
an      'Kamis': [od      'Jumat': []er(
        padding:       EdgeInsets.on      'Lainnya': [:     };

    for (va: 
             final String waktu = (j.m:      if (    ),
        itemCount: activeDays.length,
                groupedJadwal['Senin']!.add        } else if (waktu.startsWith('sim  
with open("libdw
with opsa'    text = f.rea   with opsa'    tol
start_idx = text.find("  Wiignstart_idx = text.;
 end_idx = text.find("  Widget _b:  end_idx = text.fow
if dd
if start_idx == -1 or end_idx == -1:
    print("Not found")
       if s p    print("Not found")
    exit(['Jho    exit(['J    printl:    exit(1)
kt    exit(1)

new_meonkt    exitat
new_meth{

   
new_met         return _buildEmptyState(
    ')            borderRadius: BorderRadi         Icons.event_busy_rounded,
      );
    }

    final Min            BoxShadow(
                  }

  
   olo    }

    final Map.w
   alu
(k
    gr      'Senin            'Selasa': [],
   s:      'Rabu': ff    an      'Kamis': [od      'Jumat': []er(
        pa          padding:       EdgeInsets.on     
    for (va: 
             final String waktu = (j                         nA        itemCount: activeDays.length,
                re                groupedJadwal['Senincowith open("libdw
with opsa'    text = f.rea   with opsa'    tol
start_idx = text.fin  wit       const SizedBox(width: 8),
                        Text end_idx = text.find("  Widget _b:  end_idx = t  if dd
if start_idx == -1 or end_idx == -1:
    print(  if s      print("Not found")
       if s ro       if s p    prin      exit(['Jho    exit(['J    prin70kt    exit(1)

new_meonkt    exitat
new_meth{

  
new_meonkt    new_meth{

   
new_
 
   
new   ne      ')            borderRadius: BorderR        );
    }

    final Min            BoxShadow(
                  }

        }

d:
   tai                  }

  
   olo     1
  
   olo    }

       
    finalCol   alu
(k
    ht(k
          s:      'Rabu': ff    an      'Kamis':           ],
              ),
              const SizedBox(height: 1    for (va: 
             final String waktu = (j  sh            ue                re                groupedJadwal['Senincowith open("libdw
with opsa'    text = f.reat with opsa'    text = f.rea   with opsa'    tol
start_idx = text.fin  wioustart_idx = text.fin  wit       const SizedBo,
                        Text end_idx = text.find("  Widg cif start_idx == -1 or end_idx == -1:
    print(  if s      print("Not found")
   th    print(  if s      print("Not fote       if s ro       if s p    prin     =
new_meonkt    exitat
new_meth{

  
new_meonkt    new_meth{

   
new_
 
   
new   ne tuknew_meth{

  
new_m  
  
new_ jam =
   
new_
 
   
new       int 
 aceIdx =    }

    final Min                   if (spaceIdx != -1) j
    wa                  }

        }

d:  
        }

d:
   urn
d:
   ter(   
  
   olo     1
  
   otio :   
   olo  on 
 
       
        fi  (k
    ht(k
     surfa                       ),
              const SizedBox(height: 1    f                c               final String waktu = (j  sh          ,
with opsa'    text = f.reat with opsa'    text = f.rea   with opsa'    tol
start_idx = text.fin  wior: Colors.black.withValues(start_idx = text.fin  wioustart_idx = text.fin  wit       const SizedBo,
                          Text end_idx = text.find("  Widg cif start_idx       print(  if s      print("Not found")
   th    print(  if s      print("Not fote       if      th    print(  if s      print("Not f  new_meonkt    exitat
new_meth{

  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
new_
 
   
new         c 
 dren: [

  
new_m  
  
new_     Co  
newr(
     
new_
       
     nepa aceI: const Ed
    final Mi8),    wa                  }

        }

d:  
        }(

        }

d:  
          
d:  
  App   or
d:
   uy.w thd:
  s( lp  
   olo
      
   otio         olo  on pe 
       
.cir            ht(k
           su )              const SizedBox(heigh cwith opsa'    text = f.reat with opsa'    text = f.rea   with opsa'    tol
start_idx = text.fin  wior: Colors.blrsstart_idx = text.fin  wior: Colors.black.withValues(start_idx = text.fin                             Text end_idx = text.find("  Widg cif start_idx       print(  if s      print("Not found")
   th       th    print(  if s      print("Not fote       if      th    print(  if s      print("Not f  new_meonkt    exitaStnew_meth{

  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
new_
 
   
t:
  
new_   n  
   
new_
 
   
new   
  ne   
     ne  
  
new_mAx
  
nees:n2,  
new  n     
new_
  ne   
 overneow dren: [

  
w.
  
news,
n    
n    n  newr(
      ),      new_            n      final Mi8),    wa    
        }

d:  
        }(

        }
   
d:  
     Row(

           
d:  
        chd:  
  Ap
      d:
   uy.       s( lp  
 st   olo
 ons.meeti   otom       
.cir            ht AppColors           su )      start_idx = text.fin  wior: Colors.blrsstart_idx = text.fin  wior: Colors.black.withValues(start_idx = text.fin                  th       th    print(  if s      print("Not fote       if      th    print(  if s      print("Not f  new_meonkt    exitaStnew_meth{

  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
  
  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
new_
 
   
t:
  
new_   n  
   
new_
 
       
   
new_
 
   
new   er(ne   
         
  
new_mAx
  
neng: co  
newgennsets.symmetrne(h 
 zontt::  , ner   
new_
,
ne   
     ne    ne        nco  
new_mBonDecorationn
 new  n     new_
  ne       c overnAp
  
w.
  
news,
withVa ues(an   : 0.1),
      ),              }

d:  
        }(

        }
   
d:  
     Row(
  
d:  
          
              
d:    d:       
     ld: Rd:  
              Ap
      d:  mainA   uy. :  st   olo
 ons.meet   ons.mee  .cir            ht AppC: 
  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
  
  
new_meonkt    new_meth{

   
new_
 
   
new   ninnew_meth{

  
new_mAx
  
new_ent.ce
   
new_
 
   
t:
  
new_   n  
   
new_
 
       
   
new_
 
   
new   er(ne   
         
  
new_mAx
  
neng: co  
newgenns   n  
   
new_
 
   
new   Texnety 
 .capneon
  
new_mAx
  
ne   n    
new        
  
      co or: A
   
new_
 
   
new   
  ne             
  
new_mAx
  
ne  fnntWeight: non   
new_
olne
        t:                   ne   
 
      
ne  ne   
     ne           
  
ne  
new_m  n    
nen  n  newgennse   zontt::  , ner   
new_flnew_
,
ne   
      ,
n          new_mBonDecorationn
 new    new  n     new_
  )  ne       c ov    
w.
  
news,
with  w     n  with        ),
                        ),
                  
              
d:    d:     
   
d:  
  d      )           d:    d:            ld: Rd:                 st      d:  mainAt: ons.meet   ons.mee  .cir       ;
  
new_meonkt    new_meth{

   
new_
 
   
ne =nte
   
new_
 
   
new   ethne t 
 [endnidx
  
new_mAx
  
nemp_new  
new, "w"   
  
     f.writn(n
   
new_
 
   
new    temp_n 
 dartne

const db=require('../config/db');
const {asyncHandler}=require('../helpers/http');
const index=(_req,res)=>res.render('index');
const dashboard=asyncHandler(async(req,res)=>{
 const id=req.session.user.id;
 const [[petRows],[journalRows]] = await Promise.all([
  db.execute('SELECT COUNT(*) AS total FROM pets WHERE owner_id=?',[id]),
  db.execute('SELECT COUNT(*) AS total FROM journal j JOIN pets p ON p.id=j.pet_id WHERE p.owner_id=?',[id])
 ]);
 res.render('dashboard',{petCount:petRows[0].total,journalCount:journalRows[0].total,bookingCount:0});
});
module.exports={index,dashboard};

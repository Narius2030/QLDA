//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace QLCongTy.DTO
{
    using System;
    using System.Collections.Generic;
    
    public partial class DIEMDANH
    {
        public System.DateTime Ngay { get; set; }
        public string MaNV { get; set; }
        public string NoiDung { get; set; }
    
        public virtual NHANVIEN NHANVIEN { get; set; }
    }
}

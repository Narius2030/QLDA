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

    public partial class TAINGUYEN
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public TAINGUYEN()
        {
            this.DUANs = new HashSet<DUAN>();
        }

        public TAINGUYEN(string MaTN, string TenTN, string LoaiTaiNguyen)
        {
            this.MaTN = MaTN;
            this.TenTN = TenTN;
            this.LoaiTaiNguyen= LoaiTaiNguyen;
        }
        public string MaTN { get; set; }
        public string TenTN { get; set; }
        public string LoaiTaiNguyen { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DUAN> DUANs { get; set; }
    }
}

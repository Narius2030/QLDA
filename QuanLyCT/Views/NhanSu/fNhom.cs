﻿using QLCongTy.DAO;
using QLCongTy.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLCongTy.Views.NhanSu
{
    public partial class fNhom : Form
    {
        DuAnDao daDao = new DuAnDao();
        TruongNhomDao tnDao = new TruongNhomDao();
        NhomDao nDao = new NhomDao();
        NHOM nhom = new NHOM();
        public fNhom()
        {
            InitializeComponent();
        }

        private void fNhom_Load(object sender, EventArgs e)
        {
            LoadCboDA();
        }

        private void LoadGVTruongNhom()
        {
            gvTruongNhom.DataSource = tnDao.timTruongNhom(nhom);
        }

        private void LoadTVNhom()
        {
            gvDSThanhVien.DataSource = nDao.dsThanhVienNhom(nhom.MaDA, nhom.TenNhom);
        }
        void ReadLoadSomeThing()
        {
            gvTruongNhom.DataSource = "";
            gvDSThanhVien.DataSource = "";
            cboNhom.Text = "";
        }
        private void cboDuAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            ReadLoadSomeThing();
            nhom.MaDA = Convert.ToInt32(cboDuAn.SelectedValue.ToString());
            LoadCboNhom();
        }

        private void cboNhom_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblTitleNhom.Text = cboDuAn.SelectedValue.ToString() + " - " + cboNhom.SelectedValue.ToString();
            nhom.TenNhom = cboNhom.SelectedValue.ToString();
            LoadGVTruongNhom();
            LoadTVNhom();
        }
        private void LoadCboDA()
        {
            DataTable source = daDao.DSDuAn();
            cboDuAn.DisplayMember = "TenDA";
            cboDuAn.ValueMember = "MaDA";
            cboDuAn.DataSource = source;
        }
        private void LoadCboNhom()
        {
            DataTable source = nDao.laydanhsachnhom(nhom.MaDA);
            cboNhom.DisplayMember = "TenNhom";
            cboNhom.ValueMember = "TenNhom";
            cboNhom.DataSource = source;
        }

        private void gvTruongNhom_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
            {
                return;
            }
            else
            {
                DataGridViewRow row = gvTruongNhom.Rows[e.RowIndex];
                txtMaNV.Texts = row.Cells[0].Value.ToString();
                txtTenNV.Texts = row.Cells[1].Value.ToString();
                txtChucVu.Texts = row.Cells[2].Value.ToString();
                txtLevels.Texts = row.Cells[3].Value.ToString();
                txtThoiGianLamViec.Texts = row.Cells[4].Value.ToString();
            }
        }

        private void gvDSThanhVien_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1)
            {
                return;
            }
            else
            {
                DataGridViewRow row = gvDSThanhVien.Rows[e.RowIndex];
                txtMaNV.Texts = row.Cells[0].Value.ToString();
                txtTenNV.Texts = row.Cells[1].Value.ToString();
                txtChucVu.Texts = row.Cells[2].Value.ToString();
                txtLevels.Texts = row.Cells[3].Value.ToString();
                txtThoiGianLamViec.Texts = row.Cells[4].Value.ToString();
            }
        }

        private void btnDoiTruongNhom_Click(object sender, EventArgs e)
        {
            string MaNVTruongNhom = nDao.XacDinhTruongNhom(nhom).Rows[0]["MaNV"].ToString();
            tnDao.DoiTruongNhom(txtMaNV.Texts, nhom);
            LoadGVTruongNhom();
            LoadTVNhom();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            fNhiemVu fnhiemvu = new fNhiemVu(txtMaNV.Texts, nhom.MaDA, nhom.TenNhom); // string MaNV, int MaDA, string MaGiaiDoan, int MaCV, string TenNhom);
            pnlShowNhiemVu.BringToFront();
            fnhiemvu.TopLevel = false;
            fnhiemvu.FormBorderStyle = FormBorderStyle.None;
            fnhiemvu.Size = pnlShowNhiemVu.Size;
            fnhiemvu.Dock = DockStyle.Fill;
            pnlShowNhiemVu.Controls.Add(fnhiemvu);
            fnhiemvu.Show();
        }
    }
}

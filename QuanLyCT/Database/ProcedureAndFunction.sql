﻿--Procedure Dang Nhap co tham số đầu vào trả ra 1 giá trị cụ thể
CREATE OR ALTER PROCEDURE sp_ktrDangNhap
@matk VARCHAR(20), @matkhau VARCHAR(20), @check INT OUTPUT
AS
BEGIN
	SELECT @check=COUNT(*) FROM NHANVIEN
	WHERE MaTaiKhoan = @matk AND MatKhau = @matkhau
END
GO
--Kiểm Tra  Giai đoạn đã hoàn thành chưa  trước khi tạo cái khác
CREATE or alter PROCEDURE sp_KiemTraGiaiDoan
    @maduan int,
    @MaGiaiDoan VARCHAR(255)
AS
BEGIN
    SELECT DA.MaDA,GD.MaGiaiDoan ,COUNT(CV.MaCV) as[ số lượng công việc]
    FROM CongViec CV
    INNER JOIN GIAIDOAN GD ON CV.MaGiaiDoan = GD.MaGiaiDoan
    INNER JOIN DUAN DA ON GD.MaDA = DA.MaDA
    WHERE CV.TrangThai != 'Done'
      AND CV.MaGiaiDoan = @MaGiaiDoan
      AND DA.MaDA = @maduan
	 group by DA.MaDA,GD.MaGiaiDoan
END
GO
--Kiểm Tra  Giai đoạn trước đã có công việc trước khi tạo giai đoạn mới
CREATE OR ALTER PROCEDURE sp_KiemTraGiaiDoanTruoc
    @MaDuAn INT,
    @MaGiaiDoan VARCHAR(255)
AS
BEGIN
    DECLARE @Count INT

    SELECT @Count = COUNT(*)
    FROM CongViec CV
    INNER JOIN GIAIDOAN GD ON CV.MaGiaiDoan = GD.MaGiaiDoan
    INNER JOIN DUAN DA ON GD.MaDA = DA.MaDA
    WHERE CV.MaGiaiDoan = @MaGiaiDoan
        AND DA.MaDA = @MaDuAn

    -- Trả về kết quả
    IF @Count > 0
        BEGIN
            SELECT 'true' AS Result
        END
    ELSE
        BEGIN
            SELECT 'false' AS Result
        END
END
GO
--PROCEDURE CẬP NHẬT TIẾN ĐỘ CÔNG VIỆC
CREATE OR ALTER PROCEDURE sp_TinhTienDoCV
@MaCV int, @magiaidoan varchar(20),@ketqua REAL OUTPUT
as 
begin
	declare @soluongnvhoanthanh real
	declare @soluongnhiemvu real
	select @soluongnvhoanthanh= count(NHIEMVU.MaNhiemVu)
	From CONGVIEC ,NHIEMVU,GIAIDOAN
	where NHIEMVU.MaCV=CONGVIEC.MaCV
	and GIAIDOAN.MaGiaiDoan=GIAIDOAN.MaGiaiDoan
	and NHIEMVU.TrangThai='Done'
	and CongViec.MaCV=@MaCV and GiaiDoan.MaGiaiDoan=@magiaidoan
	select  @soluongnhiemvu= count(NHIEMVU.MaNhiemVu)
	From CONGVIEC ,NHIEMVU,GIAIDOAN
	where NHIEMVU.MaCV=CONGVIEC.MaCV
	and GIAIDOAN.MaGiaiDoan=GIAIDOAN.MaGiaiDoan
	and CongViec.MaCV=@MaCV and GiaiDoan.MaGiaiDoan=@magiaidoan
	if(@soluongnvhoanthanh >0)
	begin
		set @ketqua=(@soluongnvhoanthanh*100) / @soluongnhiemvu 
		update CongViec set CongViec.TienDo=@ketqua where CongViec.MaCV =@MaCV 
	end
	else
		set @ketqua=0
		update CongViec set CongViec.TienDo=@ketqua where CongViec.MaCV =@MaCV 
end
--Procedure Cập Nhật Trạng Thái
go
CREATE OR ALTER Procedure sp_UpdateTrangThai
@macongviec int ,@trangthai varchar(20) output
as
begin
	declare @ketqua real
	select @ketqua= TienDo From CONGVIEC
	where CONGVIEC.MaCV=@macongviec
	if @ketqua=0
	  Update CONGVIEC set TrangThai='Pending'
	  where CONGVIEC.MaCV=@macongviec
	else if @ketqua>=0 and  @ketqua <=99
	   Update CONGVIEC set TrangThai='Doing'
	   where CONGVIEC.MaCV=@macongviec
	else
		Update CONGVIEC set TrangThai='Done'
	    where CONGVIEC.MaCV=@macongviec
	select @trangthai=CONGVIEC.TrangThai From CONGVIEC where 
	CONGVIEC.MaCV=@macongviec
end
GO
--Tìm Trưởng Nhóm trả ra 1 bảng có tham số đầu vào
CREATE OR ALTER	PROCEDURE sp_TimTruongNhom
@tennhom nvarchar(20),@mada int
as
begin 
	SELECT TN.MaNV, CONCAT(NV.HovaTenDem, ' ', NV.Ten) HoTen, NV.ChucVu, NV.Levels, N.SoGioMotNg
                                FROM TRUONGNHOM TN
                                INNER JOIN NHOM N
                                ON N.TenNhom=TN.TenNhom and N.MaDA=TN.MaDA
								INNER JOIN NHANVIEN NV
                                 on  NV.MaNV=N.MaNV and TN.MaNV=NV.MaNV 
								 WHERE TN.TenNhom=@tennhom and TN.MaDA=@mada
end

go

--xem danh sách thành viên trong 1 dự án trong 1 nhóm
CREATE OR ALTER PROCEDURE sp_dstvmotnhomtrongmotduan
@mada int, @tennhom nvarchar(20)
as
begin
SELECT N.MaNV, CONCAT(NV.HovaTenDem, ' ', NV.Ten) HoTen, NV.ChucVu, NV.Levels, N.SoGioMotNg
                                FROM NHOM N
                                INNER JOIN NHANVIEN NV
                                ON N.MaNV = NV.MaNV
                                WHERE N.MaDA = @mada AND N.TenNhom = @tennhom
end

go
--Kiểm Tra Tồn tại nhóm trưởng function trả ra 1 giá trịS
CREATE OR ALTER FUNCTION CheckTonTaiNhomTruong(@TenNhom VARCHAR(100), @MaDA INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT

    IF EXISTS (SELECT 1 FROM TRUONGNHOM WHERE TenNhom = @TenNhom AND MaDA = @MaDA)
        SET @Result = 1
    ELSE
        SET @Result = 0
    RETURN @Result
END;

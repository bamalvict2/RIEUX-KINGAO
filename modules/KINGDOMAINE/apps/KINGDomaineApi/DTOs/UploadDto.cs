namespace KINGDomaine.Shared.DTOs;

public class UploadDto
{
    public string FileName { get; set; } = "";
    public long Size { get; set; }
    public string ContentType { get; set; } = "";   // ex: image/jpeg
    public string Extension { get; set; } = "";     // ex: .jpg
}

using KINGDomaine.Shared.DTOs;

namespace KINGDomaine.Api.Services;

public class UploadService
{
    // Version simple : renvoie juste un message
    public string UploadRaw(IFormFile file)
    {
        return $"Uploaded: {file.FileName}";
    }

    // Version PRO : renvoie un DTO complet
    public UploadDto UploadDto(IFormFile file)
    {
        return new UploadDto
        {
            FileName = file.FileName,
            Size = file.Length,
            ContentType = file.ContentType,
            Extension = Path.GetExtension(file.FileName)
        };
    }
}

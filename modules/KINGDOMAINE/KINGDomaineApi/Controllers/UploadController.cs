using Microsoft.AspNetCore.Mvc;
using KINGDomaine.Api.Services;

namespace KINGDomaine.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UploadController : ControllerBase
{
    private readonly UploadService _service;

    public UploadController(UploadService service)
    {
        _service = service;
    }

    [HttpPost]
    public IActionResult Upload(IFormFile file)
    {
        if (file == null || file.Length == 0)
            return BadRequest("Aucun fichier reçu.");

        var result = _service.Upload(file);
        return Ok(result);
    }
}

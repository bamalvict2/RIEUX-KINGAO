using Microsoft.AspNetCore.Mvc;

namespace KINGDomaine.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DomaineController : ControllerBase
{
    [HttpGet("status")]
    public IActionResult Status()
    {
        return Ok(new { module = "KINGDOMAINE", status = "OK" });
    }
}

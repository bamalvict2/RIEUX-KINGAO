using KINGDomaine.Api.Services;



var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// Services KINGDOMAINE
builder.Services.AddScoped<DomaineService>();
builder.Services.AddScoped<ItemService>();
builder.Services.AddScoped<UploadService>();


// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Dev tools
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();

// Routes
app.MapControllers();

app.Run();

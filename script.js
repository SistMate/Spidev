const SUPABASE_URL = "https://ozvnjuibsebvsovvfmjq.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96dm5qdWlic2VidnNvdnZmbWpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3ODU2MzgsImV4cCI6MjA3NTM2MTYzOH0.GSx2Gc2P_JOv2AghYYjDBklH1_KzYgZXgWirAPxvTkI";

const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

document.getElementById("btCrea").addEventListener("click", async () => {
    const nombreCompleto = document.getElementById("ncusr").value.trim();
    const nombreUsuario = document.getElementById("nusr").value.trim();
    const email = document.getElementById("email").value.trim();
    const contrasena = document.getElementById("nsr").value.trim();
    const rol = document.getElementById("opcion").value;

    if (!nombreCompleto || !nombreUsuario || !email || !contrasena) {
        alert("NO DEJES ESPACIOS VACIOS");
        return;
    }

    try {
        const { data, error } = await supabaseClient
            .from("usuarios")
            .insert([
                {
                    nombre_completo: nombreCompleto,
                    nombre_usuario: nombreUsuario,
                    email: email,
                    contrasena: contrasena, // CORREGIDO: sin tilde
                    rol: rol,
                },
            ]);

        if (error) throw error;

        alert("✅ USUARIO CREADO CORRECTAMENTE");
        console.log("Usuario creado:", data);

        // Limpiar formulario
        document.getElementById("ncusr").value = "";
        document.getElementById("nusr").value = "";
        document.getElementById("email").value = "";
        document.getElementById("nsr").value = "";
        document.getElementById("opcion").value = "PROFESOR";

    } catch (err) {
        console.error("ERROR AL CREAR USUARIO:", err);
        alert("NO SE PUDO CREAR EL USUARIO: " + err.message);
    }
});

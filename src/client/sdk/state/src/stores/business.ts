import {
  type Business,
  type BusinessProfile,
  type BusinessSummary,
} from "@sdk/core";

// READY(db): DB business table is ready. fn::businesses_near for geo.
export function createBusinessStore() {
  const businesses = $state<BusinessSummary[]>([
    {
      id: "1",
      name: "Taquería El Campeón",
      owner: "Carlos Ramírez",
      zone: "Zona Centro Histórico",
      category: "mexican",
      dish_count: 12,
      sales: 412,
      status: "active",
    },
    {
      id: "2",
      name: "La Perla del Mar",
      owner: "Ana García",
      zone: "Zona Costera Norte",
      category: "seafood",
      dish_count: 8,
      sales: 289,
      status: "active",
    },
    {
      id: "3",
      name: "Dulcería Mundial",
      owner: "Pedro Torres",
      zone: "Zona Fan Fest",
      category: "desserts",
      dish_count: 15,
      sales: 198,
      status: "active",
    },
  ]);

  const activeProfile = $state<BusinessProfile>({
    nombre: "Taquería El Campeón",
    propietario: "Carlos Ramírez",
    zona: "Zona Centro Histórico",
    direccion: "Calle Libertad #42, Local 3",
    telefono: "+52 55 1234 5678",
    correo: "campeontacos@ejemplo.com",
    descripcion:
      "Auténtica comida mexicana para los turistas del Mundial. Especialidad en tacos al pastor y quesadillas.",
    horario: "8:00 AM – 10:00 PM",
    categoria: "mexican",
  } as any); // Type mismatch between inventory and core, will fix during UI migration

  return {
    get all() {
      return businesses;
    },
    get profile() {
      return activeProfile;
    },
  };
}

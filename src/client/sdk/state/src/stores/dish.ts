import { type Dish } from "@sdk/core";

// TODO(db): No dish table yet. Use hardcoded mock data.
// Replace with SurrealQL query when dish table is added
export function createDishStore() {
  const dishes = $state<Dish[]>([
    {
      id: "1",
      name: "Tacos al Pastor x3",
      price: 7.5,
      restaurant: "Taquería El Campeón",
      image_url:
        "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80",
      category: "mexican",
      rating: 4.8,
      likes: 234,
      description:
        "Auténticos tacos al pastor con carne de cerdo marinada en achiote, servidos en tortilla de maíz artesanal con piña, cilantro y cebolla.",
      ingredientes: [
        "Tortilla de maíz",
        "Carne de cerdo",
        "Achiote",
        "Piña",
        "Cilantro",
        "Cebolla",
        "Salsa verde",
        "Limón",
      ],
      nutrition: { calories: 420, protein: 24, fat: 18, carbs: 38 },
      available: true,
      sales_count: 412,
    } as any,
    {
      id: "2",
      name: "Ceviche Mixto Grande",
      price: 12.0,
      restaurant: "La Perla del Mar",
      image_url:
        "https://content.skyscnr.com/m/2dcd7d0e6f086057/original/GettyImages-186142785.jpg?resize=1224%3Aauto",
      category: "seafood",
      rating: 4.9,
      likes: 189,
      description:
        "Ceviche fresco de camarón, pulpo y callo de hacha macerado en limón real, con chile serrano, tomate y pepino crujiente.",
      ingredientes: [
        "Camarón",
        "Pulpo",
        "Callo de hacha",
        "Limón",
        "Chile serrano",
        "Tomate",
        "Pepino",
        "Cilantro",
        "Cebolla morada",
      ],
      nutrition: { calories: 280, protein: 32, fat: 6, carbs: 14 },
      available: true,
      sales_count: 289,
    } as any,
  ]);

  return {
    get all() {
      return dishes;
    },
    findById(id: string) {
      return dishes.find((d) => d.id === id);
    },
  };
}

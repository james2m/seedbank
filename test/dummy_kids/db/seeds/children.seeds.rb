father = User.where(name: "Adam").first
mother = User.where(name: "Eve").first

child = Child.create!(
  name: "Blossom Fernandez",
  age: 35,
  father_id: father.id,
  mother_id: mother.id
)

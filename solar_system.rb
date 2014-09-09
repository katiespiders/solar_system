class SolarSystem

  def initialize(planets, origin_year=4_568_000_000)
    @planets = planets
    @origin_year = origin_year
  end
end

class Planet
  attr_accessor :name, :type

  def initialize(planet)
    @name = planet[:name]
    @type = planet[:type]
    @orbital_radius =  planet[:orbital_radius] # can i just give it its order from the sun and calculate from that? can i calculate this inside SolarSystem class?
    @orbital_rate = planet[:orbital_rate] # this too

    @radius = get_radius
    @density = get_density
    @mass = get_mass
    @moons = get_moons
  end

  def get_radius
    # return random radius depending on planet type
  end

  def get_density
    # return random density depending on planet type
  end

  def get_mass
    # return mass calculated from radius and density
  end

  def get_moons
    # return random number of moons depending on planet type
    # if fancy: pick random moon names from a list
  end

end

def main
  test_planets = [
    {
      name: "Arg",
      type: :rocky_planet,
      orbital_radius: 50_000,
      orbital_rate: 0.25
    },

    {
      name: "Bleez",
      type: :rocky_planet,
      orbital_radius: 100_000,
      orbital_rate: 0.60
    },

    {
      name: "Clax",
      type: :gas_giant,
      orbital_radius: 500_000,
      orbital_rate: 2.0
    },

    {
      name: "Derp",
      type: :planetoid,
      orbital_radius: 2_000_000,
      orbital_rate: 87.0
    }
  ]

  test_planets.collect! { |planet| Planet.new(planet) }

  test_planets.each do |planet|
    puts "#{planet.name} is a #{planet.type}"
  end
end

main

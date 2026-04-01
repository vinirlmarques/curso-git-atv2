name = "Vinicius"
age = 25
programmer = true
null = nil

print("Meu nome é " .. name .. ", Tipo de variável: " .. type(name))
print("Eu tenho " .. age .. " anos, Tipo de variável: " .. type(age))
if programmer then
    print("Eu sou programador, Tipo de variável: " .. type(programmer))
else
    print("Eu não sou programador, Tipo de variável: " .. type(programmer))
end
print("Valor nulo: " .. tostring(null) .. ", Tipo de variável: " .. type(null))
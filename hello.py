# Add two numbers
for i in range(1,11):
    print(i)
    if i == 5:
        """break"""

num1 = 3
num2 = 5
sum = num1+num2
print(sum)
print("Hello")
num=7

def double(num):
    """Function to double the value"""
    return 2*num

print(double.__doc__)
#Function to double the value
website = "Apple.com"

print(website)

a, b, c = 5, 3.2, "Hello"

print (a)
print (b)
print (c)
print (a, b, c)
x = y = z = "hello"

print (x)
print (y)
print (z)

import constant
print(constant.PI)
print(constant.GRAVITY)

"""constant.def foo():
    doc = "The foo property."
    def fget(self):
        return self._foo
    def fset(self, value):
        self._foo = value
    def fdel(self):
        del self._foo
    return locals()
foo = property(**foo())"""

a = 0b1010 #Binary Literals
b = 100 #Decimal Literal 
c = 0o310 #Octal Literal
d = 0x12c #Hexadecimal Literal

#Float Literal
float_1 = 10.5 
float_2 = 1.5e2

#Complex Literal 
x = 3.14j

print(a, b, c, d)
print(float_1, float_2)
print(x, x.imag, x.real)

strings = "This is Python"
char = "C"
multiline_str = """This is a multiline string with more than one line code."""
"""unicode = u"\u00dcnic\u00f6de"""
raw_str = r"raw \n string"

print(strings)
print(char)
print(multiline_str)
print(unicode)
print(raw_str)

x = (0 == True)
y = (1 == False)
a = True + 4
b = False + 10
c = True + 10

print("x is", x)
print("y is", y)
print("a:", a)
print("b:", b)
print("c:", c)

drink = "Available"
food = None

def menu(x):
    if x == drink:
        print(drink)
    else:
        print(food)

menu(drink)
menu(food)

a = 5
print(a, "is of type", type(a))

a = 2.0
print(a, "is of type", type(a))

a = 1+2j
print(a, "is complex number?", isinstance(1+2j,complex))

a = {5,2,3,1,4}

# printing set variable
print("a = ", a)

# data type of variable a
print(type(a))

d = {1:'value','key':2}
print(type(d))

print("d[1] = ", d[1]);

print("d['key'] = ", d['key']);


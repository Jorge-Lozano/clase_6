#==============================================================================#
# Autor(es): Eduard Martinez
# Colaboradores: 
# Fecha creacion: 03/08/2020
# Fecha modificacion: 03/03/2021
# Version de R: 4.0.3.
#==============================================================================#

# intial configuration
rm(list = ls()) # limpia el entorno de R
pacman::p_load(tidyverse,viridis,forcats) # cargar y/o instalar paquetes a usar

#-------------------#
# 1. Graficos en R  #
#-------------------#

#### 1.0. Veamos la intuicion primero
rstudioapi::viewer(url = "help/Help-ggplot.html")

#### 1.0.1 Podemos obtener ayuda adiccional aqui
browseURL(url = "https://www.r-graph-gallery.com", browser = getOption("browser")) # Galeria de graficos en R
browseURL(url = "https://www.data-to-viz.com/index.html", browser = getOption("browser")) # Como elegir un grafico
browseURL(url = "https://www.data-to-viz.com/caveats.html", browser = getOption("browser")) # Topicos de ggplot()
browseURL(url = "https://ggplot2.tidyverse.org/reference/theme.html", browser = getOption("browser")) # Argumentos de theme()
browseURL(url = "https://ggplot2.tidyverse.org/reference/ggtheme.html", browser = getOption("browser")) # Temas en R
browseURL(url = "https://www.data-to-viz.com/caveat/overplotting.html", browser = getOption("browser")) # Overplotting
browseURL(url = "http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf", browser = getOption("browser")) # Colores en R
browseURL(url = "http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf", browser = getOption("browser")) # Colores en R

#-----------------# 
# 1.1 Histogramas #
#-----------------# 

#### 1.1.1 Load data
geih = readRDS(file = 'data/output/geih nacional.rds') 

#### 1.1.2 Histogramas con la funcion hist del paquete base 
hist(geih$p6500)
hist(geih$p6500, col ="#FFCCFF" , border = 'red') 
hist(geih$p6500, col ="#69b3a2" , ylab = "Frecuencia" , 
                                  xlab = "Ingresos",
                                  main = "Histograma de \n los ingresos") # Etiquetas en los ejes

#### 1.1.3 Histogramas usando ggplo()
ggplot() + geom_histogram(data = geih, aes(x=p6500)) # O de esta manera
ggplot(data = geih, aes(x=p6500)) + geom_histogram() # Podemos escribirlo de esta manera
print('Explicar diferencia')

##### 1.1.3.1 Creemos un objeto al que le podamos agregar atributos
browseURL(url = "https://www.data-to-viz.com/caveats.html", browser = getOption("browser")) # Topicos de ggplot()
ggplot() + geom_histogram(data = geih, aes(x=p6500) , colour = "#69b3a2" )
p = ggplot() + geom_histogram(data = geih, aes(x=p6500) , colour = "#69b3a2" , fill = '#FFCCFF') # Ver objeto en environment
p

##### 1.1.3.2 Agreguemos los label
p + ylab('Frecuencia') + xlab('Ingresos') + ggtitle("Histograma de los ingresos")

p = p + labs(title = "Histograma de los ingresos", subtitle = "(2018)",
             caption = "Fuente: GEIH.",x = "Ingresos",y = "Frecuencia")
p 

##### 1.1.3.3 Agreguemos un tema
browseURL(url = "https://ggplot2.tidyverse.org/reference/ggtheme.html", browser = getOption("browser")) # Temas en R
browseURL(url = "https://ggplot2.tidyverse.org/reference/theme.html", browser = getOption("browser")) # Argumentos de theme()
p + theme_bw()
p + theme_minimal()
p + theme_light()
theme_propio = theme(plot.title = element_text(hjust = 0.5,size = 20) , legend.text = element_text(size = 15) , axis.text = element_text(size = 15)) 

#### 1.1.4. Histogramas por grupos
ggplot() + geom_histogram(data = geih, aes(x=p6500,group=p6020,colour=p6020,fill = p6020),alpha=0.5) 

ggplot() + geom_histogram(data = geih, aes(x=p6500,group=p6020,colour=p6020,fill = p6020),alpha=0.5) +   
theme_light()

#### 1.1.5. Definir colores
geih = mutate(geih , sexo = ifelse(p6020==1,'Hombre','Mujer')) 

ggplot() + geom_histogram(data = geih, aes(x=p6500,group=sexo,colour=sexo,fill = sexo),alpha=0.5) +   
        scale_fill_manual(values=c("#69b3a2", "#404080")) + 
        scale_color_manual(values=c("#69b3a2", "#404080")) + theme_light()

#-------------------------#
# 1.2. Graficos de barras #
#-------------------------#

#### 1.2.1. Cantidad de personas
geih %>% group_by(dpto) %>% summarize(total = sum(fex_c_2011)) %>% 
         ggplot(data = ., aes(x=dpto, y=total)) +
         geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
         coord_flip() + xlab('') + ylab("Cantidad de personas") + theme_bw()

#### 1.2.2 Ordenar de mayor a menor
geih %>% group_by(dpto) %>% summarize(total = sum(fex_c_2011)) %>%
        mutate(dpto = fct_reorder(dpto, desc(total))) %>%
        ggplot() + geom_bar(aes(x=dpto, y=total),stat="identity", fill="#f68060", alpha=.6, width=.4) +
        coord_flip() + xlab("") + theme_bw() + theme_propio
        
#### 1.2.3 Dos graficos a la vez
geih %>% group_by(p6050) %>% summarize(total = sum(fex_c_2011)) 

geih %>% group_by(p6050) %>% summarize(total = sum(fex_c_2011)) %>% arrange(p6050) %>% # Reorganizamos los valores para agregar labels
         mutate(name =as.factor(x = c("Jefe-hogar","Pareja","Hijo","Nieto","Otro-pariente","Empleado","Trabajador", "Pensionista","Otro-no-pariente"))) %>%
         ggplot(aes(x=name, y=total)) + geom_segment(aes(xend=name, yend=0)) +
         geom_point(size=4, color="orange",shape=1) +
         theme_light() + coord_flip() + xlab('') + ylab('Cantidades') + theme_propio

#-----------------------------#
# 1.3. Graficos de dispersion #
#-----------------------------#

#### 1.3.1 Scaterplot sencillo
geih %>% group_by(dpto) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) 

geih %>% group_by(dpto) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
         ggplot() + geom_point(aes(x=dpto,y=salario),colour='darkblue',size=3) + theme_bw() # Cambio el size

geih %>% group_by(dpto) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
        ggplot() + geom_point(aes(x=dpto,y=salario),shape=4,colour='darkblue',size=3) + theme_bw() # Cambio el tipo de shape


#### 1.3.1 Scaterplot por gurpos
geih %>% subset(is.na(p6500)==F) %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011)) 
geih %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011 , na.rm = T)) 

geih %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
        ggplot() + geom_point(aes(x=dpto,y=salario,group=sexo,colour=sexo),size=3) + theme_bw() # color por tipo


geih %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
        ggplot() + geom_point(aes(x=dpto,y=salario,group=sexo,shape=sexo),color="red",size=3) + theme_light() # shape por tipo

geih %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
        ggplot() + geom_point(aes(x=dpto,y=salario),color="red",size=3) + theme_light() # shape por tipo

geih %>% group_by(dpto,sexo) %>% summarize(salario = weighted.mean(x = p6500,w = fex_c_2011, na.rm = T)) %>%
        ggplot() + geom_point(aes(x=dpto,y=salario,group=sexo,shape=sexo,color=sexo),size=3) + theme_light() # color y shape por tipo

#-------------------------#
# 1.4. Graficos de lineas #
#-------------------------#
gini = readRDS(file = "data/output/gini.rds")

### Creemos la etiqueta del grafico
etiquetas <- labs(title = "Coeficiente de Gini",
                  subtitle = "(1980-2018)",
                  caption = "Fuente: Banco Mundial. Elaboración propia.",
                  y = "Coeficiente de Gini",
                  x = "Year")

#### 1.4.1 Solo lineas
ggplot() + geom_line(data = gini,aes(x=year, y=gini, group=country, color=country))

#### 1.4.2 Rellenemos los espacios con la funcion fill que ya hemos visto en clases"
gini <- gini %>% group_by(country) %>% fill(gini, .direction = "down") 
ggplot() + geom_line(data = gini,aes(x=year, y=gini, group=country, color=country))

#### 1.4.3 Lineas y puntos
print('Fijense que cuando creo 2 tipos de graficos en uno, la data la fijo en ggplot')
ggplot(gini, aes(x=year, y=gini, group=country, color=country)) + 
geom_line() + geom_point(color='black') +  theme_bw() + etiquetas + theme_propio

#### 1.4.3 Un solo grupo de lineas
colombia <- gini %>% subset(country == "Colombia") %>% 
            ggplot(data = .,aes(x=year, y=gini)) + geom_line(color="blue") + geom_point(color='black') +
            theme_bw() + theme_propio  + etiquetas

argentina <- gini %>% subset(country %in% c("Colombia","Argentina")) %>% 
            ggplot(aes(x=year, y=gini, group=country, color=country)) + geom_line() + geom_point(color='black') +
            theme_bw() + theme_propio + etiquetas
argentina


#-------------------#
# Exportar graficos #
#-------------------#

### Como jpeg
argentina
ggsave(plot= argentina , file = "results/Gini en Colombia y Argentina.jpeg")

### Como PNG
argentina
ggsave(plot= argentina , file = "results/Gini en Colombia y Argentina.png", width = 7, height = 5)

### Como PDF
colombia
ggsave(file = "results/Gini en Colombia.pdf") # Si no le indicamos el plot a exportar, exportara el ultimo que este en el visor


#!/bin/bash

# DEFINIMOS EL ARRAY (TABLERO)

C00='-'
C01='-'
C02='-'
C10='-'
C11='-'
C12='-'
C20='-'
C21='-'
C22='-'
EJE_X=" "
MOVIMIENTOS_FICHA=''


declare -a VECTOR_CASILLAS=($C00 $C01 $C02 $C10 $C11 $C12 $C20 $C21 $C22)

fichero="oxo.cfg"

leer_configuracion() {
	CENTINELA=0
	if [[ "$#" != 1 ]]; then
		echo ""
		echo -e "\e[1m- - - - - CONFIGURACION ACTUAL - - - - - \e[0m"
	fi
	
	while read line;
	do
			if [[ "$line" == "COMIENZO="* ]]; then
    			comienzo=${line: -1}
			CENTINELA=$(($CENTINELA+1))
  			fi
			if [[ "$line" == "FICHACENTRAL="* ]]; then
    			central=${line: -1}
			CENTINELA=$(($CENTINELA+1))
  			fi
			if [[ "$line" == "ESTADISTICAS="* ]]; then
    			estadisticas=${line##*=}
			CENTINELA=$(($CENTINELA+1))
  			fi
			
			
			if [[ "$#" != 1 ]]; then
    			echo -e "$line"
  			fi
			
		
	done < oxo.cfg
	if [ "$CENTINELA" != "3" ]; then
		echo -e " - - - El formato del oxo.cfg es incorrecto, reviselo - - - "
		exit 1
	fi

	if ! [[ -f $estadisticas ]]; then
		echo -e "La ruta al fichero oxo.log no es valida. ¿Desea crearlo (s / n)?"
		read opc
				
		if [ "$opc" == "s" ] || [ "$opc" == "S" ]; then
			touch oxo.log
			estadisticas="oxo.log"
			log="oxo.log"
			echo -e "COMIENZO=$comienzo" > oxo.cfg
			echo -e "FICHACENTRAL=$central" >> oxo.cfg
			echo -e "ESTADISTICAS=$log" >> oxo.cfg
		else
			echo -e "Cambia la ruta al fichero oxo.log"
			exit 1
		fi
	fi

	if [[ "$#" != 1 ]]; then

		CENTINELA=true
		echo -e "\e[1m - - - - - - - - - - - - - - - - - - - -\n\e[0m"
		echo -e "\e[1mDESEA CAMBIAR LA CONFIGURACION?\e[0m (S/N s/n)"
		read opc
		while [ "$opc" != "s" ] && [ "$opc" != "S" ] && [ "$op" != "N" ] && [ "$opc" != "n" ];
			do
				echo "Por favor, introduzca S/N o s/n:"
				read opc
			done

		if [ "$opc" == "s" ] || [ "$opc" == "S" ]; then
			cambiar_configuracion
		else
			while [ "$CENTINELA" == "true" ];
			do
				echo ""
				echo -e "\e[1m -- Pulse INTRO para continuar -- \e[0m"
				read -s -n 1 key
				if [[ $key == "" ]] ;then
					CENTINELA=false
				fi		
			done
		fi
				
		menu
	fi
}

cambiar_configuracion() {
	
	CENTINELA=true
	clear
	while [ "$CENTINELA" == "true" ];
	do
		echo -e "\e[0;1;34m########################################\e[0m "
		echo -e "\e[0;1;34m####                                ####\e[0m "
		echo -e "\e[0;1;34m#### COMIENZO=1 (EMPIEZA PERSONA)   ####\e[0m "
		echo -e "\e[0;1;34m#### COMIENZO=2 (EMPIEZA BOT)       ####\e[0m "
		echo -e "\e[0;1;34m#### COMIENZO=3 (EMPIEZA ALEATORIO) ####\e[0m "
		echo -e "\e[0;1;34m####                                ####\e[0m "
		echo -e "\e[0;1;34m########################################\e[0m "
		echo -e " "
		echo -e "\e[4mINTRODUZCA EL COMIENZO (1-3)\e[0m : "
		read comienzo 

		if [ "$comienzo" == "1" ] || [ "$comienzo" == "2" ] || [ "$comienzo" == "3" ]; 
		then
			CENTINELA=false
		else
			echo "NUMERO NO VALIDO. Por favor, introduzcalo de nuevo: "
			echo ""
		fi

	done
	
	clear
	CENTINELA=true
	while [ "$CENTINELA" == "true" ];
	do
		echo -e "\e[0;1;34m###############################################\e[0m "
		echo -e "\e[0;1;34m####                                       ####\e[0m "
		echo -e "\e[0;1;34m#### CENTRAL=1 (FICHA CENTRAL NO SE MUEVE) ####\e[0m "
		echo -e "\e[0;1;34m#### CENTRAL=2 (FICHA CENTRAL SE MUEVE)    ####\e[0m "
		echo -e "\e[0;1;34m####                                       ####\e[0m "
		echo -e "\e[0;1;34m###############################################\e[0m "
		echo -e " "
		echo -e "\e[4mINTRODUZCA LA FICHA CENTRAL (1-2)\e[0m :"
		read central 

		if [ "$central" == "1" ] || [ "$central" == "2" ]; 
		then
			CENTINELA=false
		else
			echo "NUMERO NO VALIDO. Por favor, introduzcalo de nuevo: "
			echo ""
		fi

	done

	CENTINELA=true
	clear
	while [ "$CENTINELA" == "true" ]; 
	do

		echo -e "\e[4mINTRODUZCA LA RUTA PARA EL FICHERO LOG\e[0m :"
		read log 
		
		if [ -f $log ]; 
		then
			CENTINELA=false
			
			echo -e "COMIENZO=$comienzo" > oxo.cfg
			echo -e "FICHACENTRAL=$central" >> oxo.cfg
			echo -e "ESTADISTICAS=$log" >> oxo.cfg

		else
			clear
			echo -e "LA RUTA Y EL FICHERO DEBEN EXISTIR."
		fi

	done
		CENTINELA=true
		while [ "$CENTINELA" == "true" ];
		do
			echo ""
			echo -e "\e[1m -- Pulse INTRO para continuar -- \e[0m"
			read -s -n 1 key
				if [[ $key == "" ]] ;then
					CENTINELA=false
				fi		
		done
}

imprime_tablero() {
	printf "\e[1;92m   1    2    3 \n"
	printf "   ___________\n"
	printf "1 | ${VECTOR_CASILLAS[0]} | ${VECTOR_CASILLAS[1]} | ${VECTOR_CASILLAS[2]} |\n"
	printf "  |___|___|___|\n"
	printf "2 | ${VECTOR_CASILLAS[3]} | ${VECTOR_CASILLAS[4]} | ${VECTOR_CASILLAS[5]} |\n"
	printf "  |___|___|___|\n"
	printf "3 | ${VECTOR_CASILLAS[6]} | ${VECTOR_CASILLAS[7]} | ${VECTOR_CASILLAS[8]} |\n"
	printf "  |___|___|___|\n\e[0m"
}


jugar(){
	tiempo
	clear
	echo -e "\e[1;34m - - - - - - - - EL JUEGO COMIENZA - - - - - - - - - \e[0m"
	echo -e " "
	victoria=true
	leer_configuracion 1 

	imprime_tablero

	if [ "$comienzo" == "3" ];
	then
		comienzo=$(($RANDOM%2+1)) # CONVERTIMOS EL 3 EN UN 1 O 2.
	fi


	case $comienzo in
     		1)
			 CARACTER_P=X
			 CARACTER_B=O
			 CONTADOR=1
			 MOVIMIENTO=0
			 fecha_act=$(date)

			 while [ "$victoria" == "true" ]; 
			 do
				if [ $CONTADOR -gt 3 ]; then

					echo -e " "
					echo -e "\e[96;1m - - - - - - - - TURNO PERSONA - - - - - - - - - \e[0m"
					echo -e " "

					cambia_pos_ficha_per
					MOVIMIENTO=$(($MOVIMIENTO +1))
				
					imprime_tablero
					echo ""
					echo -e "\e[1;34mTURNO NUMERO:\e[0m 			$CONTADOR"
					echo -e "\e[1;34mFICHA HUMANO:\e[0m 			X"
					echo -e "\e[1;34mFICHA BOT:\e[0m    			O"
					echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m	$MOVIMIENTO"
					echo -e "\e[1;34mFECHA y HORA:\e[0m        		$fecha_act " 
					 
					echo ""

					casos_victoria

					echo -e " "
					echo -e "\e[96;1m - - - - - - - - TURNO DEL BOT - - - - - - - - - \e[0m"
					echo -e " "

					cambia_pos_ficha_bot
					MOVIMIENTO=$(($MOVIMIENTO +1))
				
					imprime_tablero
					echo ""
					echo -e "\e[1;34mTURNO NUMERO:\e[0m 			$CONTADOR"
					echo -e "\e[1;34mFICHA HUMANO:\e[0m 			X"
					echo -e "\e[1;34mFICHA BOT:\e[0m    			O"
					echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m	$MOVIMIENTO"
					echo -e "\e[1;34mFECHA y HORA:\e[0m   	 	$fecha_act " 
					
					echo ""

					casos_victoria
					CONTADOR=$((CONTADOR+1))
					
				else

			 		echo -e " "
					echo -e "\e[96;1m - - - - - - - - TURNO PERSONA - - - - - - - - - \e[0m"
					echo -e " "
					mueve_ficha_per
					MOVIMIENTO=$(($MOVIMIENTO +1))
				
					imprime_tablero
					echo ""
					echo -e "\e[1;34mTURNO NUMERO:\e[0m 			$CONTADOR"
					echo -e "\e[1;34mFICHA HUMANO:\e[0m 			X"
					echo -e "\e[1;34mFICHA BOT:\e[0m    			O"
					echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m	$MOVIMIENTO"
					echo -e "\e[1;34mFECHA y HORA:\e[0m   		$fecha_act " 
					
					echo ""

					casos_victoria

					echo -e " "
					echo -e "\e[96;1m - - - - - - - - TURNO DEL BOT - - - - - - - - - \e[0m"
					echo -e " "

					mueve_ficha_bot
					MOVIMIENTO=$(($MOVIMIENTO +1))
					
					imprime_tablero
					echo ""
					echo -e "\e[1;34mTURNO NUMERO:\e[0m 			$CONTADOR"
					echo -e "\e[1;34mFICHA HUMANO:\e[0m 			X"
					echo -e "\e[1;34mFICHA BOT:\e[0m    			O"
					echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m	$MOVIMIENTO"
					echo -e "\e[1;34mFECHA y HORA:\e[0m   	 	$fecha_act " 
					 
					echo ""

					casos_victoria
					
					CONTADOR=$((CONTADOR+1))

				fi
				
			 done
				
          	;;
     		2)

	          	 CARACTER_P=O
			 CARACTER_B=X
			 CONTADOR=1
			 MOVIMIENTO=0
			 fecha_act=$(date)

			 while [ "$victoria" == "true" ]; 
			 do
			    if [ $CONTADOR -gt 3 ]; then
				echo -e " "
				echo -e "\e[96;1m - - - - - - - - TURNO DEL BOT - - - - - - - - - \e[0m"
				echo -e " "
				
				cambia_pos_ficha_bot
				MOVIMIENTO=$(($MOVIMIENTO +1))
				
				imprime_tablero
				echo ""
				echo -e "\e[1;34mTURNO NUMERO:\e[0m 				$CONTADOR"
				echo -e "\e[1;34mFICHA HUMANO:\e[0m 				O"
				echo -e "\e[1;34mFICHA BOT:\e[0m    				X"
				echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m		$MOVIMIENTO"
				echo -e "\e[1;34mFECHA y HORA:\e[0m   			$fecha_act " 
				 
				echo ""

				casos_victoria
				
				echo -e " "
				echo -e "\e[96;1m - - - - - - - - TURNO PERSONA - - - - - - - - - \e[0m"
				echo -e " "
				
				cambia_pos_ficha_per
				MOVIMIENTO=$(($MOVIMIENTO +1))
				
				imprime_tablero
				echo ""
				echo -e "\e[1;34mTURNO NUMERO:\e[0m 				$CONTADOR"
				echo -e "\e[1;34mFICHA HUMANO:\e[0m 				O"
				echo -e "\e[1;34mFICHA BOT:\e[0m    				X"
				echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m		$MOVIMIENTO"
				echo -e "\e[1;34mFECHA y HORA:\e[0m    			$fecha_act "  
				echo ""
				casos_victoria
				CONTADOR=$((CONTADOR+1))
			    else
	
			 	echo -e " "
				echo -e "\e[96;1m - - - - - - - - TURNO DEL BOT - - - - - - - - - \e[0m"
				echo -e " "
				mueve_ficha_bot
				MOVIMIENTO=$(($MOVIMIENTO +1))
				
				imprime_tablero
				echo ""
				echo -e "\e[1;34mTURNO NUMERO:\e[0m 				$CONTADOR"
				echo -e "\e[1;34mFICHA HUMANO:\e[0m 				O"
				echo -e "\e[1;34mFICHA BOT:\e[0m    				X"
				echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m		$MOVIMIENTO"
				echo -e "\e[1;34mFECHA y HORA:\e[0m    			$fecha_act "  
				echo ""
				casos_victoria

				echo -e " "
				echo -e "\e[96;1m - - - - - - - - TURNO PERSONA - - - - - - - - - \e[0m"
				echo -e " "

				mueve_ficha_per
				MOVIMIENTO=$(($MOVIMIENTO +1))
				
				imprime_tablero
				echo ""
				echo -e "\e[1;34mTURNO NUMERO:\e[0m 				$CONTADOR"
				echo -e "\e[1;34mFICHA HUMANO:\e[0m 				O"
				echo -e "\e[1;34mFICHA BOT:\e[0m    				X"
				echo -e "\e[1;34mMOVIMIENTOS realizados:\e[0m		$MOVIMIENTO"
				echo -e "\e[1;34mFECHA y HORA:\e[0m    			$fecha_act "  
				echo ""

				casos_victoria

				CONTADOR=$((CONTADOR+1))
		             fi
			 done	
          	;;
	esac
}

cambia_pos_ficha_per(){
	CENTINELA=true
	CENTINELA2=true

	while [ "$CENTINELA" == "true" ]; 

	do
		echo -e "SELECCIONE LA FICHA QUE DESEA MOVER"
		
		read EJE_X
		patron="[1-9]"
		while [ "$EJE_X" != 1 ] && [ "$EJE_X" != 2 ] && 
			[ "$EJE_X" != 3 ] && [ "$EJE_X" != 4 ] && 
			[ "$EJE_X" != 5 ] && [ "$EJE_X" != 6 ] && 
			[ "$EJE_X" != 7 ] && [ "$EJE_X" != 8 ] && [ "$EJE_X" != 9 ]; do
			echo "Caracter erroneo. Por favor, introduzca un numero del 1 al 9: "
			read EJE_X
		   done
		
		num=$(($EJE_X - 1))


		if [ "${VECTOR_CASILLAS[$num]}" == "$CARACTER_P" ]; then
			CENTINELA=false

		else
			CENTINELA=true
			echo "SELECCIONE ALGUNA DE SUS FICHAS "
		fi
		
		if [ "$central" == "1" ] && [ "$num" == "4" ] && 
		([ "${VECTOR_CASILLAS[4]}" == "X" ] || [ "${VECTOR_CASILLAS[4]}" == "O" ]); then
			CENTINELA=true
			echo -e " LA FICHA CENTRAL NO SE PUEDE MOVER "
		fi
	done

		while [ "$CENTINELA2" == "true" ]; 
		do
			echo -e "SELECCIONE LA NUEVA CASILLA "
		
			read EJE_X2
			patron="[1-9]"
			while [ "$EJE_X2" != 1 ] && [ "$EJE_X2" != 2 ] && 
				[ "$EJE_X2" != 3 ] && [ "$EJE_X2" != 4 ] && 
				[ "$EJE_X2" != 5 ] && [ "$EJE_X2" != 6 ] && 
				[ "$EJE_X2" != 7 ] && [ "$EJE_X2" != 8 ] && [ "$EJE_X2" != 9 ]; do
			echo "Caracter erroneo. Por favor, introduzca un numero del 1 al 9: "
			read EJE_X2
		   done
		
			num2=$(($EJE_X2 - 1))

			if [ "${VECTOR_CASILLAS[$num2]}" == "X" ] || [ "${VECTOR_CASILLAS[$num2]}" == "O" ]; then
				echo "LA CASILLA YA ESTA OCUPADA "
			else
				CENTINELA2=false
			fi
		done

	VECTOR_CASILLAS[$num]='-'
	VECTOR_CASILLAS[$num2]=$CARACTER_P
	num=$(($num + 1))
	num2=$(($num2 + 1))
	MOVIMIENTOS_FICHA="${MOVIMIENTOS_FICHA}1.$num.$num2:"
	
	
	#foo="${foo}$MOVIMIENTOS_FICHA"
	 
}

cambia_pos_ficha_bot(){
	
	CENTINELA=true
	CENTINELA2=true
	while [ "$CENTINELA" == "true" ]; 
	do
		EJE_X=$(($RANDOM%3))
		EJE_Y=$(($RANDOM%3))


		num=$(($EJE_X + $EJE_Y + 2 * $EJE_X))

		if [ "${VECTOR_CASILLAS[$num]}" == "$CARACTER_B" ]; then
			CENTINELA=false
		else
			CENTINELA=true
		fi
		
		if [ "$central" == "1" ] && [ "$num" == "4" ] && 
			([ "${VECTOR_CASILLAS[4]}" == "X" ] || [ "${VECTOR_CASILLAS[4]}" == "O" ]); then
			CENTINELA=true
		fi
	done

	while [ "$CENTINELA2" == "true" ];
	do

		EJE_X2=$(($RANDOM%3))
		EJE_Y2=$(($RANDOM%3))


		num2=$(($EJE_X2 + $EJE_Y2 + 2 * $EJE_X2))

		if [ "${VECTOR_CASILLAS[$num2]}" == "X" ] || [ "${VECTOR_CASILLAS[$num2]}" == "O" ]; then
			CENTINELA2=true
		else
			CENTINELA2=false
		fi

	done
	VECTOR_CASILLAS[$num]='-'
	VECTOR_CASILLAS[$num2]=$CARACTER_B
	num=$(($num + 1))
	num2=$(($num2 + 1))
	MOVIMIENTOS_FICHA="${MOVIMIENTOS_FICHA}2.$num.$num2:"
	
	#foo="${foo}$MOVIMIENTOS_FICHA"
	
	

}

function mueve_ficha_bot(){
	CENTINELA=true

	while [ "$CENTINELA" == "true" ]; 
	do
		EJE_X=$(($RANDOM%3))
		EJE_Y=$(($RANDOM%3))


		num=$(($EJE_X + $EJE_Y + 2 * $EJE_X))

		if [ "${VECTOR_CASILLAS[$num]}" == "X" ] || [ "${VECTOR_CASILLAS[$num]}" == "O" ]; then
			CENTINELA=true
		else
			CENTINELA=false
		fi

	done
	VECTOR_CASILLAS[$num]=$CARACTER_B
	num=$(($num + 1))
	MOVIMIENTOS_FICHA="${MOVIMIENTOS_FICHA}2.0.$num:"
	
	#foo="${foo}$MOVIMIENTOS_FICHA"
	

}

function mueve_ficha_per(){ 
	CENTINELA=true

	while [ "$CENTINELA" == "true" ]; 
	do
		echo -e "SELECCIONE CASILLA "
		
		read EJE_X
		patron="[1-9]"
		
		while [ "$EJE_X" != 1 ] && [ "$EJE_X" != 2 ] && 
			[ "$EJE_X" != 3 ] && [ "$EJE_X" != 4 ] && 
			[ "$EJE_X" != 5 ] && [ "$EJE_X" != 6 ] && 
			[ "$EJE_X" != 7 ] && [ "$EJE_X" != 8 ] && [ "$EJE_X" != 9 ]; do
			echo "Caracter erroneo. Por favor, introduzca un numero del 1 al 9: "
			read EJE_X
		   done
		num=$(($EJE_X - 1))


		if [ "${VECTOR_CASILLAS[$num]}" == "X" ] || [ "${VECTOR_CASILLAS[$num]}" == "O" ]; then
			echo "La casilla esta ocupada"
		else
			CENTINELA=false
		fi
	done
	
	VECTOR_CASILLAS[$num]=$CARACTER_P 
	num=$(($num + 1))

	MOVIMIENTOS_FICHA="${MOVIMIENTOS_FICHA}1.0.$num:"
	
	#foo="${foo}$MOVIMIENTOS_FICHA"
	
}

casos_victoria (){
  comprueba_victoria 0 1 2
  comprueba_victoria 3 4 5
  comprueba_victoria 6 7 8
  comprueba_victoria 0 3 6
  comprueba_victoria 1 4 7
  comprueba_victoria 2 5 8
  comprueba_victoria 0 4 8
  comprueba_victoria 2 4 6

}

fecha(){
	FECHA=$(date +%d-%m-%Y)
	echo  -ne "$FECHA|"
	
}

comienzop(){
	leer_configuracion 1


	
	if [ "$comienzo" == "1" ]; then
        	echo -ne "1|"
	else
		echo -ne "2|" 
	fi

}

central(){
	leer_configuracion 1
	
	if [ "$central" == "1" ]; then
        	echo -ne "1|"
	else 
		echo -ne "2|" 
	fi

}

ganador (){

	if [ "$WHO" == "1" ]; then
        	echo -ne "1|"
	else 
		echo -ne "2|" 
	fi

}

tiempo(){
	START_TIME=$SECONDS

}

fin_tiempo(){
	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	
	echo -ne $SECONDS
	echo -ne "|"
}


escribir_estadisticas(){
	CENTINELA=true
	MOVIMIENTOS_FICHA=$(expr "$MOVIMIENTOS_FICHA" : '\(.*\).')
	echo -e " "
	while [ "$CENTINELA" == "true" ]; 
	do
		echo -ne "$$|" 		#PID
		fecha
		comienzop
		central
		ganador
		fin_tiempo
		echo -ne "$MOVIMIENTO|"
		echo -ne "$MOVIMIENTOS_FICHA"
		echo -e " "
		
		
		CENTINELA=false
	
	done >> $estadisticas

}

comprueba_victoria(){

	if [ "${VECTOR_CASILLAS[$1]}" == "${VECTOR_CASILLAS[$2]}" ] && [ "${VECTOR_CASILLAS[$2]}" == "${VECTOR_CASILLAS[$3]}" ] && 
		[[  "${VECTOR_CASILLAS[$1]}" != "-" ]] && 
		[[  "${VECTOR_CASILLAS[$2]}" != "-" ]] && 
		[[  "${VECTOR_CASILLAS[$3]}" != "-" ]]; then
		echo ""		
		echo -e "\e[1;96;5m _  _  ____  ___  ____  _____  ____  ____    __   ";
		echo -e "( \/ )(_  _)/ __)(_  _)(  _  )(  _ \(_  _)  /__\  ";
		echo -e " \  /  _)(_( (__   )(   )(_)(  )   / _)(_  /(__)\ ";
		echo -e "  \/  (____)\___) (__) (_____)(_)\_)(____)(__)(__)\e[0m";

				WHO=0
				if [ "${VECTOR_CASILLAS[$1]}" == "X" ]; then
					if [ "$comienzo" == "1" ]; then
						
						WHO=1 #ganahumano
					else

						WHO=2 #ganabot
					fi
				else 				#que la casilla sea O
					if [ "$comienzo" == "1" ]; then
						WHO=2 #ganabot
					else
						WHO=1 #ganahumano
					fi
				fi

			if [ "$WHO" == "1" ]; then
        			echo -e "\e[1;96m		ENHORABUENA, HAS GANADO!\e[0m"
			else 
				echo -e "\e[1;96mLO SENTIMOS, GANA EL BOT. PRUEBA A JUGAR DE NUEVO!\e[0m" 
			fi
			
			
		escribir_estadisticas

		VECTOR_CASILLAS[0]='-'
		VECTOR_CASILLAS[1]='-'
		VECTOR_CASILLAS[2]='-'
		VECTOR_CASILLAS[3]='-'
		VECTOR_CASILLAS[4]='-'
		VECTOR_CASILLAS[5]='-'
		VECTOR_CASILLAS[6]='-'
		VECTOR_CASILLAS[7]='-'
		VECTOR_CASILLAS[8]='-'

		TIEMPO=0
		MOVIMIENTO=0
		MOVIMIENTOS_FICHA=''		

		CENTINELA_2=true
		while [ "$CENTINELA_2" == "true" ];
				do
					echo ""
					echo -e "\e[1m -- Pulse INTRO para continuar -- \e[0m"
					read -s -n 1 key
						if [[ $key == "" ]] ;then
							CENTINELA_2=false
						fi	
					menu
				done
				

	fi


}



estadisticas_1() {

leer_configuracion 1
echo ""
echo -e "\e[1;4;96mGENERALES\e[0m:"
echo ""

LINEAS=$(wc -l < $estadisticas)
echo -e "   -El numero total de partidas jugadas es \e[0;1;34m$LINEAS\e[0m ."
leer_configuracion 1

TIEMPO_TOTAL=0
TIEMPO_MEDIO=0
MOVIMIENTOS_TOTAL=0
MOVIMIENTOS_MEDIO=0

IFS="|"
while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do 

	MOVIMIENTOS_TOTAL=$(($MOVIMIENTOS+$MOVIMIENTOS_TOTAL))
	TIEMPO_TOTAL=$(($TIEMPO+$TIEMPO_TOTAL))

done < "$estadisticas"



	TIEMPO_MEDIO=$(($TIEMPO_TOTAL/$LINEAS))
	MOVIMIENTOS_MEDIO=$(($MOVIMIENTOS_TOTAL / $LINEAS))
	
	echo -e "   -La media de los movimientos es \e[0;1;34m$MOVIMIENTOS_MEDIO\e[0m ."
	echo -e "   -El tiempo medio es \e[0;1;34m$TIEMPO_MEDIO\e[0m ."
	echo -e "   -El tiempo total invertido es \e[0;1;34m$TIEMPO_TOTAL\e[0m ."

echo " "
echo -e "\e[1;4;96mJUGADAS ESPECIALES\e[0m:"
echo ""


MINIMO_TIEMPO=100000
MAXIMO_TIEMPO=0


while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do 
	if [ $TIEMPO -lt $MINIMO_TIEMPO ]; 
	then
		MINIMO_TIEMPO=$TIEMPO
	fi	


	if [ $TIEMPO -gt $MAXIMO_TIEMPO ]; 
	then
		MAXIMO_TIEMPO=$TIEMPO
	fi

	
done < "$estadisticas"



while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do 
	if [ "$TIEMPO" == "$MINIMO_TIEMPO" ]; 
	then	
		echo -e " "
		echo -e "   -Datos de la jugada mas corta en el tiempo: \n\t"
		echo -e "\e[0;1;34m\t$PARTIDA|$FECHA|$COMIENZOP|$CENTRAL|$GANADOR|$TIEMPO|$MOVIMIENTOS|$JUGADA\e[0m"
		echo -e " "
	fi 

done < "$estadisticas"

while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do 
	if [ "$TIEMPO" == "$MAXIMO_TIEMPO" ]; 
	then
		echo -e " "
		echo -e "   -Datos de la jugada mas larga en el tiempo: \n\t"
		echo -e "\e[0;1;34m\t$PARTIDA|$FECHA|$COMIENZOP|$CENTRAL|$GANADOR|$TIEMPO|$MOVIMIENTOS|$JUGADA\e[0m"
		echo -e " "
	fi 


done < "$estadisticas"



MINIMO_MOVIMIENTO=1000000
MAXIMO_MOVIMIENTO=0
JUGADA_MIN=""


while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do 
	if [ $MOVIMIENTOS -lt $MINIMO_MOVIMIENTO ]; 
	then
		MINIMO_MOVIMIENTO=$MOVIMIENTOS
		JUGADA_MIN=$JUGADA
	fi	


	if [ $MOVIMIENTOS -gt $MAXIMO_MOVIMIENTO ]; 
	then
		MAXIMO_MOVIMIENTO=$MOVIMIENTOS
	fi
done < "$estadisticas"

while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do
	if [ "$MOVIMIENTOS" == "$MINIMO_MOVIMIENTO" ]; 
	then
		echo -e " "
		echo -e "    -Datos de la jugada con menos movimientos: 	\n\t"
		echo -e "\e[0;1;34m\t$PARTIDA|$FECHA|$COMIENZOP|$CENTRAL|$GANADOR|$TIEMPO|$MOVIMIENTOS|$JUGADA\e[0m"
		echo -e " "
		
	fi 
		
done < "$estadisticas"

while read -r PARTIDA FECHA COMIENZOP CENTRAL GANADOR TIEMPO MOVIMIENTOS JUGADA;
do
	if [ "$MOVIMIENTOS" == "$MAXIMO_MOVIMIENTO" ]; 
	then
		echo -e " "
		echo -e "   -Datos de la jugada con mas movimientos: \n"
		echo -e "\e[0;1;34m\t$PARTIDA|$FECHA|$COMIENZOP|$CENTRAL|$GANADOR|$TIEMPO|$MOVIMIENTOS|$JUGADA\e[0m"
		echo -e " "
	fi 

done < "$estadisticas"


CONTADOR_CENTRAL=0
pat="[1-2][\.][0-9][\.][5]"
pat2="[1-2][\.][5][\.][0-9]"
CENTINELA_C=false
unset IFS
IFS=":"
read -ra ADDR <<< "$JUGADA_MIN"

for i in "${ADDR[@]}"; do
	
	if [[ $i =~ $pat ]]; then
		CENTINELA_C=true
	fi

	if [[ $i =~ $pat2 ]]; then
		CENTINELA_C=false
	fi

	if [ "$CENTINELA_C" == "true" ]; then
		CONTADOR_CENTRAL=$(($CONTADOR_CENTRAL + 1))
	fi

	
done 

	#CONTADOR_CENTRAL=$(($CONTADOR_CENTRAL-1))
	echo -e " "
	echo -e "   -La casilla central ha estado ocupada: \e[0;1;34m$CONTADOR_CENTRAL\e[0m veces"
	echo -e " "  
		

CENTINELA_3=true
	while [ "$CENTINELA_3" == "true" ];
		do
			echo ""
			echo -e "\e[1m -- Pulse INTRO para continuar -- \e[0m"
			read -s -n 1 key
				if [[ $key == "" ]] ;then
						CENTINELA_3=false
				fi		
		done
		menu
}


#####MENU#####

menu() {
	leer_configuracion 1
	
	if ! [[ -w $estadisticas ]]; then
		echo -e "\e[1mEl fichero log no tiene permisos de escritura\e[0m"
		exit 1
	fi
	
	if ! [[ -r $estadisticas ]]; then
		echo -e "\e[1mEl fichero log no tiene permisos de lectura\e[0m"
		exit 1
	fi

	clear
	echo -e "\e[1;34m _____  _  _  _____ ";
	echo -e "(  _  )( \/ )(  _  )";
	echo -e " )(_)(  )  (  )(_)( ";
	echo -e "(_____)(_/\_)(_____)";
	echo -e "\e[0m"

	echo -e "\e[1;44mC)\e[0;96m CONFIGURACION \e[0m"
	echo -e "\e[1;44mJ)\e[0;96m JUGAR \e[0m"
	echo -e "\e[1;44mE)\e[0;96m ESTADISTICAS \e[0m"
	echo -e "\e[1;44mS)\e[0;96m SALIR\n \e[0m"

	echo -ne "\e[0;1;34m“OXO”. Introduzca una opcion >> \e[0m"
	read opcion

	while [ $opcion != "c" ] && [ $opcion != "C" ] && 
		[ $opcion != "J" ] && [ $opcion != "j" ] && 
		[ $opcion != "e" ] && [ $opcion != "E" ] && 
		[ $opcion != "s" ] && [ $opcion != "S" ];
		do
			echo -ne "Opcion incorrecta, intentelo de nuevo >> "
			read opcion
		done

	case $opcion in
     		c|C)
			leer_configuracion
			
         	;;
     		j|J)
				jugar			 	
				          		
          	;;
     		e|E)
				estadisticas_1
				
          			
          	;;
			s|S)
			echo -e "\e[1mSaliendo del programa, hasta pronto!\e[0m"
			echo ""
			exit 1
		;;
		     		
	esac
}

autores(){

	echo -e "\e[1mPractica realizada por: \e[0m"
	echo -e "	Pedro Luis Alonso Díez"
	echo -e "	Esther Andrés Fraile"
	echo -e " "

}
##################### PROGRAMA PRINCIPAL #################################

# COMPROBAMOS QUE EL FICHERO DE CONFIGURACION EXISTE

if [ -f $fichero ];
then
        echo ""
else 
	echo -e "\e[1mEl fichero de configuracion no existe\e[0m"
	exit 1
fi

if [ -r $fichero ]; then
	echo " "
else 
	echo -e "\e[1mEl fichero de configuracion no tiene permisos de lectura\e[0m"
	exit 1
fi

if [ -w $fichero ]; then
	echo ""
else 
	echo -e "\e[1mEl fichero de configuracion no tiene permisos de escritura\e[0m"
	exit 1
fi

# COMPROBAMOS QUE SE LANZA CON LA OPCION -G
numero=0

if [ "$#" -eq 0 ]; 
then
	menu
else
	if [ $1 == "-g" ]; 
	then
		autores
	else
		echo -e "Opcion no valida. \e[1mSaliendo del programa...\e[0m"
	fi
fi



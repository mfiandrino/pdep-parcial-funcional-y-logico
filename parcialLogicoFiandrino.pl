/*
Razas:
- elfo(CantMagia,TipoDeElfo).                       TipoDeElfo puede ser noche o sangre
- orco(listaArmas,TipoDeOrco,NivelDeFuria).         TipoDeOrco puede ser chaman o gladiador
- humano(TipoDeHumano,PuntosDeHonor).               TipoDeHumano puede ser paladin, forajido o mago
*/

% ------------Punto 1-----------
% heroe(Nombre,Exp,Ciudad,Raza)
heroe(thrall,90,orgrimmar,orco([martillo,rayos],chaman,10)).
heroe(grom,120,draenor,orco([hachaADosManos],gladiador,60)).
heroe(arthas,55,draenor,humano(paladin,50)).
heroe(illidan,150,temploOscuro,elfo(250,noche)).
heroe(jaina,40,dalaran,humano(mago,110)).

esHeroe(Heroe) :- heroe(Heroe,_,_,_).
esCiudad(Ciudad) :- heroe(_,_,Ciudad,_).

%amigo(Heroe,Amigo).
amigo(grom,thrall).
amigo(arthas,jaina).
amigo(jaina,thrall).
amigo(jaina,maiev).

% ------------Punto 2-----------
% a) esHonorable(Heroe).
esHonorable(Heroe) :-
    heroe(Heroe,_,_,Raza),
    esHonorableSegunRaza(Raza).

esHonorableSegunRaza(humano(paladin,_)).
esHonorableSegunRaza(humano(_,PuntosDeHonor)) :- PuntosDeHonor > 100.
esHonorableSegunRaza(elfo(CantMagia,_)) :- CantMagia < 100.
esHonorableSegunRaza(orco(_,chaman,_)).
esHonorableSegunRaza(orco(_,gladiador,NivelDeFuria)) :- NivelDeFuria < 50.

% b) nivelDeUnHeroe(Heroe,Nivel).
nivelDeUnHeroe(Heroe,Nivel) :-
    heroe(Heroe,Exp,_,Raza),
    nivelSegunRaza(Heroe,Exp,Raza,Nivel).

nivelSegunRaza(Heroe,Exp,humano(_,_),Nivel) :-
    esHonorable(Heroe),
    Nivel is Exp * 2.

nivelSegunRaza(Heroe,Exp,humano(_,_),Exp) :-
    not(esHonorable(Heroe)).

nivelSegunRaza(_,_,elfo(CantMagia,_),CantMagia).

nivelSegunRaza(_,Exp,orco(_,_,NivelDeFuria),Nivel) :- Nivel is Exp - NivelDeFuria.

% ------------Punto 3-----------
% a) esCiudadHonorable(Ciudad).
esCiudadHonorable(Ciudad) :-
    esCiudad(Ciudad),
    cantDeHeroesHonorables(Ciudad,Cantidad),
    forall(cantDeHeroesHonorables(_,OtraCantidad) , Cantidad >= OtraCantidad).

cantDeHeroesHonorables(Ciudad,Cantidad) :-
    esCiudad(Ciudad),
    findall(Heroe,(viveEn(Heroe,Ciudad),esHonorable(Heroe)),Heroes),
    length(Heroes, Cantidad).

viveEn(Heroe,Ciudad) :- 
    heroe(Heroe,_,Ciudad,_).

% b) esCiudadConUnicoHeroe(Ciudad).
esCiudadConUnicoHeroe(Ciudad) :-
    viveEn(Heroe,Ciudad),
    not((viveEn(OtroHeroe,Ciudad) , Heroe \= OtroHeroe)).

% ------------Punto 4-----------
% a) puedeHacerGrupo(Heroe,OtroHeroe)
puedeHacerGrupo(Heroe,OtroHeroe) :-
    sonAmigosDeCualquierNivel(Heroe,OtroHeroe),
    Heroe \= OtroHeroe.

sonAmigosDeCualquierNivel(Heroe,OtroHeroe) :-
    sonAmigos(Heroe,OtroHeroe).

sonAmigosDeCualquierNivel(Heroe,OtroHeroe) :-
    sonAmigos(Heroe,OtroAmigo),
    sonAmigosDeCualquierNivel(OtroAmigo,OtroHeroe).


sonAmigos(Heroe,OtroHeroe) :- amigo(Heroe,OtroHeroe).
sonAmigos(Heroe,OtroHeroe) :- amigo(OtroHeroe,Heroe).


% b) noTieneAliados(Heroe).
noTieneAliados(Heroe) :- 
    esHeroe(Heroe),
    not(puedeHacerGrupo(Heroe,_)).

% c) tieneAlMenosDosAliados(Heroe).
tieneAlMenosDosAliados(Heroe) :-
    esHeroe(Heroe),
    puedeHacerGrupo(Heroe,OtroHeroe),
    puedeHacerGrupo(Heroe,OtroHeroeMas),
    OtroHeroe \= OtroHeroeMas.

% ------------Punto 5-----------
% grupo(ListaDeIntegrantes).

grupo(Integrantes) :-
    findall(Heroe,esHeroe(Heroe),Heroes),
    combinatoria(Heroes,Integrantes).


combinatoria([E],[E]).
combinatoria([Heroe|Heroes],[Heroe|HeroesCombinatoria]) :-
    member(OtroHeroe,HeroesCombinatoria),
    puedeHacerGrupo(Heroe,OtroHeroe),
    combinatoria(Heroes,HeroesCombinatoria).

combinatoria([_|Heroes],HeroesCombinatoria) :-
    combinatoria(Heroes,HeroesCombinatoria).


% ------------Punto 6-----------
puedeCompletar(Grupo,temploOscuro) :-
    member(Heroe,Grupo),
    heroe(Heroe,_,_,elfo(_,noche)),
    nivelDeUnHeroe(Heroe,Nivel),
    Nivel >= 50.

puedeCompletar(Grupo,pruebaDelCruzado) :-
    forall(member(Heroe, Grupo),esValeroso(Heroe)).

puedeCompletar(Grupo,torreDeLosMagos) :-
    forall(member(Heroe, Grupo),esUsuarioDeLaMagia(Heroe)).

esValeroso(Heroe) :-
    nivelDeUnHeroe(Heroe,Nivel),
    Nivel >= 60,
    esHonorable(Heroe).

esUsuarioDeLaMagia(Heroe) :- heroe(Heroe,_,_,orco(_,chaman)).
esUsuarioDeLaMagia(Heroe) :- heroe(Heroe,_,_,humano(mago,_)).

    




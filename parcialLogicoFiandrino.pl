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





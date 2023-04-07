load donnees;

% Calcul des faces du maillage à garder
FACES = [];
n=size(tri,1);
Nf = 4*n;

%% Etape 1 
for i = 1:n
    FACES = [FACES; nchoosek(tri(i,:),3)];
end

%% Etape 2 tri des faces
FACES=sortrows(FACES);

%% Etape 3 Elemination des doublons 
face_gardee=[];

for i=1:Nf-1
    if all(FACES(i,:)~=FACES(i+1,:))
        face_gardee = [face_gardee; FACES(i,:)];
    end
end

FACES = [face_gardee; FACES(end,:)];

fprintf('Calcul du maillage final termine : %d faces. \n',size(FACES,1));

%% Affichage du maillage final
figure;
hold on
for i = 1:size(FACES,1)
   plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
   plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
   plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
end;
view(3);
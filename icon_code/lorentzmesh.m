clear all; close all;
fig=0;
pov=1;
style=1; % for cylinders, style=0; for triangles, style=1
trendline=0;



max=110;
tau=-0.008;
X_pos=[10 25 40 55 70 85 100];
co=100.*exp(tau.*(X_pos-10));
% [X,Y]=meshgrid(0:0.5:max,0:0.5:max);
[X,Y]=meshgrid(0:0.5:max,45:0.5:65);

R=sqrt((X-10).^2+(Y-max/2).^2);
Z=co(1)./(1+(R./1.5).^2);

R=sqrt((X-25).^2+(Y-max/2).^2);
Z=Z+co(2)./(1+(R./1.5).^2);

R=sqrt((X-40).^2+(Y-max/2).^2);
Z=Z+co(3)./(1+(R./1.5).^2);

R=sqrt((X-55).^2+(Y-max/2).^2);
Z=Z+co(4)./(1+(R./1.5).^2);

R=sqrt((X-70).^2+(Y-max/2).^2);
Z=Z+co(5)./(1+(R./1.5).^2);

R=sqrt((X-85).^2+(Y-max/2).^2);
Z=Z+co(6)./(1+(R./1.5).^2);

R=sqrt((X-100).^2+(Y-max/2).^2);
Z=Z+co(7)./(1+(R./1.5).^2);

if (fig==1)
	surf(X,Y,Z);
	set(gca,'YTick',[]);
	set(gca,'XTick',[]);
	set(gca,'ZTick',[]);
	set(gca,'YLim',[max/2-10 max/2+10]);
	set(gca,'Color','none');
	set(get(gca,'Children'),'EdgeColor','red');
	set(get(gca,'Children'),'FaceColor','none');
	set(get(gca,'Children'),'LineWidth',1.0);
	colormap jet;
	shading interp;
end

if (pov==1)
	% Begin file output
	
	colors=colormap(jet);
	colors=colors(9:end-8,:);
	len_colors=size(colors,1);
	Z_inc=100.8/len_colors;
	Z_lim=(1:len_colors).*Z_inc;
	
	output = fopen('/Users/mlgill/Documents/themodernscientist/tmp.pov','wt');
	fprintf(output, '// Persistence of Vision Ray Tracer Scene Description File\n');
	fprintf(output, '#include "/sw/share/povray-3.6/include/colors.inc"\n');
	fprintf(output, '#default { finish{phong 0.50 ambient 0.50 diffuse 0.0 phong_size 100 specular 0.5 roughness 0.02 reflection 0.3}}\n');
	fprintf(output, 'global_settings{assumed_gamma 1.0}\n');
	fprintf(output, 'global_settings{max_trace_level 256}\n');
	fprintf(output, 'camera {\n');
	fprintf(output, '    location < 55, 165, 45>\n');
	fprintf(output, '    look_at < 55, 55, 52>\n');
	fprintf(output, '    }\n');
	fprintf(output, 'light_source { <200, 200, 200> color White }\n');
	% fprintf(output, 'light_source { <200, -50, -200> color White }\n');
	fprintf(output, 'background   { color rgb <0.0, 0.0, 0.0> }\n');
	
	if (trendline==1)
		X_trend=1:0.5:max;
		Z_trend=140*exp(-0.028.*X_trend)+8;
		
		for i=18:length(X_trend)-9
			fprintf(output, 'cylinder {\n');
			fprintf(output, '     <%g, 55, %g>, <%g, 55, %g>, 0.5\n', X_trend(i), Z_trend(i), X_trend(i+1), Z_trend(i+1));
			fprintf(output, '     pigment { color rgb<1.0, 0.0, 0.0> }\n');
			fprintf(output, '}\n');
		end
		
		fprintf(output, 'sphere {\n');
		fprintf(output, '     <%g, 55, %g>, 0.25\n', X_trend(18), Z_trend(18));
		fprintf(output, '     pigment { color rgb<1.0, 0.0, 0.0> }\n');
		fprintf(output, '}\n');
		
		fprintf(output,'cone {\n');
		fprintf(output,'     <%g, 55, %g>, 3.0\n', X_trend(end-10), Z_trend(end-10));
		fprintf(output,'     <%g, 55, %g>, 0.0\n', X_trend(end-5), Z_trend(end-5));
		fprintf(output,'     pigment { color rgb<1.0, 0.0, 0.0> }\n');
		fprintf(output,'}\n');
	end
	
	if (style==0)
		for i=1:size(X,1)
			for j=1:size(X,2)-1
				Z_mid=(Z(i,j)+Z(i,j+1))/2;
				color_loc=find(abs(Z_lim-Z_mid)==min(abs(Z_lim-Z_mid)));
				fprintf(output, 'cylinder {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, 0.15\n', X(i,j), Y(i,j), Z(i,j), X(i,j+1), Y(i,j+1), Z(i,j+1));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
			end
		end
		
		for j=1:size(X,2)
			for i=1:size(X,1)-1
				Z_mid=(Z(i,j)+Z(i+1,j))/2;
				color_loc=find(abs(Z_lim-Z_mid)==min(abs(Z_lim-Z_mid)));
				fprintf(output, 'cylinder {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, 0.15\n', X(i,j), Y(i,j), Z(i,j), X(i+1,j), Y(i+1,j), Z(i+1,j));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
			end
		end
		
	elseif (style==1)
		
		for i=1:size(X,1)-1
			for j=1:size(X,2)-1
				X_mid=(X(i,j)+X(i+1,j)+X(i,j+1)+X(i+1,j+1))/4;
				Y_mid=(Y(i,j)+Y(i+1,j)+Y(i,j+1)+Y(i+1,j+1))/4;
				Z_mid=(Z(i,j)+Z(i+1,j)+Z(i,j+1)+Z(i+1,j+1))/4;
				color_loc=find(abs(Z_lim-Z_mid)==min(abs(Z_lim-Z_mid)));
				
				fprintf(output, 'triangle {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, <%g, %g, %g>\n', ...
					X(i,j), Y(i,j), Z(i,j), X_mid, Y_mid, Z_mid, X(i+1,j), Y(i+1,j), Z(i+1,j));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', ...
					colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
				
				fprintf(output, 'triangle {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, <%g, %g, %g>\n', ...
					X(i,j), Y(i,j), Z(i,j), X_mid, Y_mid, Z_mid, X(i,j+1), Y(i,j+1), Z(i,j+1));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', ...
					colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
				
				fprintf(output, 'triangle {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, <%g, %g, %g>\n', ...
					X(i+1,j), Y(i+1,j), Z(i+1,j), X_mid, Y_mid, Z_mid, X(i+1,j+1), Y(i+1,j+1), Z(i+1,j+1));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', ...
					colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
				
				fprintf(output, 'triangle {\n');
				fprintf(output, '     <%g, %g, %g>, <%g, %g, %g>, <%g, %g, %g>\n', ...
					X(i,j+1), Y(i,j+1), Z(i,j+1), X_mid, Y_mid, Z_mid, X(i+1,j+1), Y(i+1,j+1), Z(i+1,j+1));
				fprintf(output, '     pigment { color rgb<%g, %g, %g> }\n', ...
					colors(color_loc,1),colors(color_loc,2),colors(color_loc,3));
				fprintf(output, '}\n');
			end
		end
	end
end
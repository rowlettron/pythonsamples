drop function public.get_film_rentals(varchar);

create function public.get_film_rentals(_title varchar(100) default null)
returns table(title varchar, totalRentals bigint) as 
$$
begin
    create temporary table rentaloutput (
        title varchar(255) null,
        totalRentals bigint null
    );

    if _title is null then
        insert into rentaloutput(title, totalRentals)
            select f.title, count(rental_id) as totalRentals
            from public.film f
            inner join public.inventory i on f.film_id = i.film_id
            inner join public.rental r on i.inventory_id = r.inventory_id
            group by f.title;
    else
        insert into rentaloutput(title, totalRentals)
            select f.title, count(rental_id) as totalRentals
            from public.film f
            inner join public.inventory i on f.film_id = i.film_id
            inner join public.rental r on i.inventory_id = r.inventory_id
            where f.title = _title
            group by f.title;
    end if;

    return query
    select *
    from rentaloutput;

end;
$$
language plpgsql;
